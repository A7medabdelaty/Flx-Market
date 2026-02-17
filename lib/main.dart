import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/constants/nav_colors.dart';
import 'package:flx_market/Core/services/service_initializer.dart';
import 'package:flx_market/Services/auth/data/repositories/auth_repository_impl.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_bloc.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_event.dart';
import 'package:flx_market/Services/home/data/repositories/home_repository_impl.dart';
import 'package:flx_market/Services/home/presentation/bloc/home_bloc.dart';
import 'package:flx_market/Services/home/presentation/bloc/home_event.dart';
import 'package:flx_market/Services/products/data/repositories/products_repository_impl.dart';
import 'package:flx_market/Services/products/presentation/bloc/add_product_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_event.dart';
import 'package:flx_market/Services/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flx_market/routes/app_routes.dart';
import 'package:flx_market/routes/route_constants.dart';

import 'bloc_observer.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepositoryImpl()),
        RepositoryProvider(create: (context) => HomeRepositoryImpl()),
        RepositoryProvider(create: (context) => ProductsRepositoryImpl()),
        RepositoryProvider(create: (context) => WishlistRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepositoryImpl>())
                  ..add(AuthCheckStatusEvent()),
            lazy: false,
          ),
          BlocProvider(
            create: (context) =>
                HomeBloc(homeRepository: context.read<HomeRepositoryImpl>())
                  ..add(LoadHomeDataEvent()),
          ),
          BlocProvider(
            create: (context) => ProductsBloc(
              productsRepository: context.read<ProductsRepositoryImpl>(),
            )..add(LoadProductsEvent()),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              wishlistRepository: context.read<WishlistRepositoryImpl>(),
            )..add(LoadWishlistEvent()),
          ),
          BlocProvider(
            create: (context) => AddProductBloc(
              productsRepository: context.read<ProductsRepositoryImpl>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flx',
          theme: ThemeData(
            scaffoldBackgroundColor: NavColors.navBgColor,
            primaryColor: NavColors.navSelectColor,
            useMaterial3: true,
          ),
          initialRoute: RouteConstants.splash,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
