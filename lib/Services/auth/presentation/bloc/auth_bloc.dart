import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  UserCredential? _pendingCredential;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthCheckStatusEvent>(_onAuthCheckStatus);
    on<AuthSignInWithEmailEvent>(_onSignInWithEmail);

    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignUpWithEmailEvent>(_onSignUpWithEmail);
    on<AuthCompleteProfileEvent>(_onCompleteProfile);
    on<AuthUpdateProfileEvent>(_onUpdateProfile);
    on<AuthResetPasswordEvent>(_onResetPassword);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthErrorEvent>(_onAuthError);

    _setupAuthStateSubscription();
  }

  void _setupAuthStateSubscription() {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        add(AuthCheckStatusEvent());
      },
      onError: (error) {
        add(AuthErrorEvent(error.toString()));
      },
    );
  }

  Future<void> _emitAuthenticatedUser(
    String uid,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.getUserProfile(uid);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await _emitAuthenticatedUser(user.uid, emit);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthError(
    AuthErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthFailure(event.message));
  }

  Future<void> _onSignInWithEmail(
    AuthSignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithEmail(
      event.email,
      event.password,
    );

    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (userCredential) async =>
          await _emitAuthenticatedUser(userCredential.user!.uid, emit),
    );
  }

  Future<void> _onSignUpWithEmail(
    AuthSignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signUpWithEmail(
      event.email,
      event.password,
      event.name,
      event.phone,
      event.role,
    );

    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (userCredential) async =>
          await _emitAuthenticatedUser(userCredential.user!.uid, emit),
    );
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogle();

    await result.fold((failure) async => emit(AuthFailure(failure.message)), (
      userCredential,
    ) async {
      final exists = await _authRepository.checkUserExists(
        userCredential.user!.uid,
      );
      if (exists) {
        await _emitAuthenticatedUser(userCredential.user!.uid, emit);
      } else {
        _pendingCredential = userCredential;
        emit(AuthNeedsRoleSelection(userCredential));
      }
    });
  }

  Future<void> _onCompleteProfile(
    AuthCompleteProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_pendingCredential == null) {
      emit(AuthFailure("No pending registration found. Please try again."));
      return;
    }

    emit(AuthLoading());
    final result = await _authRepository.createUserProfile(
      _pendingCredential!,
      event.role,
    );

    await result.fold((failure) async => emit(AuthFailure(failure.message)), (
      _,
    ) async {
      await _emitAuthenticatedUser(_pendingCredential!.user!.uid, emit);
      _pendingCredential = null;
    });
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedUser = currentState.user.copyWith(
        name: event.name,
        phone: event.phone,
      );

      emit(AuthLoading());
      final result = await _authRepository.updateUserProfile(
        updatedUser,
        imageFile: event.imageFile,
      );

      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    }
  }

  Future<void> _onResetPassword(
    AuthResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.sendPasswordResetEmail(event.email);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthPasswordResetSent()),
    );
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
