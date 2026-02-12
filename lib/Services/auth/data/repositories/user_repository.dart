import 'package:flx_market/Core/constants/firestore_collections.dart';
import 'package:flx_market/Core/services/firebase/firestore_service.dart';
import 'package:flx_market/Services/auth/domain/entities/user.dart' as domain;

class UserRepository {
  final FirestoreService _firestoreService;
  static const String collection = FirestoreCollections.users;

  UserRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService.instance;

  Future<void> createUser(domain.User user) async {
    await _firestoreService.create(collection, user.id, user.toMap());
  }

  Future<domain.User?> getUser(String userId) async {
    return await _firestoreService.read(
      collection,
      userId,
      domain.User.fromMap,
    );
  }

  Future<void> updateUser(domain.User user) async {
    await _firestoreService.update(collection, user.id, user.toMap());
  }
}
