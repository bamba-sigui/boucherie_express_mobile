// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user.dart' as _i111;
import '../../features/auth/domain/usecases/sign_in_with_email.dart' as _i485;
import '../../features/auth/domain/usecases/sign_out.dart' as _i568;
import '../../features/auth/domain/usecases/sign_up_with_email.dart' as _i460;
import '../../features/auth/domain/usecases/update_user_profile.dart' as _i901;
import '../../features/auth/domain/usecases/watch_auth_changes.dart' as _i497;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/cart/data/datasources/cart_local_datasource.dart'
    as _i339;
import '../../features/cart/data/repositories/cart_repository_impl.dart'
    as _i642;
import '../../features/cart/domain/repositories/cart_repository.dart' as _i322;
import '../../features/cart/domain/usecases/add_to_cart.dart' as _i868;
import '../../features/cart/domain/usecases/get_cart.dart' as _i912;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i517;
import '../../features/favorites/data/datasources/favorites_remote_datasource.dart'
    as _i904;
import '../../features/favorites/data/repositories/favorites_repository_impl.dart'
    as _i144;
import '../../features/favorites/domain/repositories/favorites_repository.dart'
    as _i212;
import '../../features/favorites/domain/usecases/get_favorites.dart' as _i418;
import '../../features/favorites/domain/usecases/toggle_favorite.dart' as _i189;
import '../../features/favorites/presentation/bloc/favorites_bloc.dart'
    as _i429;
import '../../features/filter/data/repositories/filter_repository_impl.dart'
    as _i1033;
import '../../features/filter/domain/repositories/filter_repository.dart'
    as _i131;
import '../../features/filter/domain/usecases/apply_filter.dart' as _i530;
import '../../features/filter/domain/usecases/reset_filter.dart' as _i460;
import '../../features/filter/presentation/bloc/filter_bloc.dart' as _i1006;
import '../../features/home/data/datasources/home_local_datasource.dart'
    as _i314;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/get_home_categories.dart' as _i159;
import '../../features/home/domain/usecases/get_home_favorite_ids.dart'
    as _i884;
import '../../features/home/domain/usecases/get_home_products.dart' as _i303;
import '../../features/home/domain/usecases/search_home_products.dart' as _i816;
import '../../features/home/domain/usecases/toggle_product_favorite.dart'
    as _i101;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i804;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/check_onboarding_status.dart'
    as _i474;
import '../../features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i561;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/onboarding/presentation/bloc/splash_bloc.dart' as _i302;
import '../../features/orders/data/datasources/order_local_datasource.dart'
    as _i303;
import '../../features/orders/data/datasources/order_remote_datasource.dart'
    as _i1007;
import '../../features/orders/data/repositories/order_repository_impl.dart'
    as _i376;
import '../../features/orders/domain/repositories/order_repository.dart'
    as _i543;
import '../../features/orders/domain/usecases/create_order.dart' as _i725;
import '../../features/orders/domain/usecases/get_order_by_id.dart' as _i43;
import '../../features/orders/domain/usecases/get_user_orders.dart' as _i299;
import '../../features/orders/presentation/bloc/order_bloc.dart' as _i298;
import '../../features/products/data/datasources/product_remote_datasource.dart'
    as _i333;
import '../../features/products/data/repositories/product_repository_impl.dart'
    as _i764;
import '../../features/products/domain/repositories/product_repository.dart'
    as _i963;
import '../../features/products/domain/usecases/get_all_products.dart' as _i910;
import '../../features/products/domain/usecases/get_categories.dart' as _i2;
import '../../features/products/domain/usecases/get_product_by_id.dart'
    as _i147;
import '../../features/products/presentation/bloc/product_bloc.dart' as _i28;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => appModule.firebaseFirestore);
    gh.lazySingleton<_i457.FirebaseStorage>(() => appModule.firebaseStorage);
    gh.lazySingleton<_i1007.OrderRemoteDataSource>(
        () => _i1007.OrderRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i314.HomeLocalDataSource>(
        () => _i314.HomeLocalDataSourceImpl());
    gh.lazySingleton<_i339.CartLocalDataSource>(
        () => _i339.CartLocalDataSourceImpl());
    gh.lazySingleton<_i303.OrderLocalDataSource>(
        () => _i303.OrderLocalDataSourceImpl());
    gh.lazySingleton<_i333.ProductRemoteDataSource>(
        () => _i333.ProductRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i322.CartRepository>(
        () => _i642.CartRepositoryImpl(gh<_i339.CartLocalDataSource>()));
    gh.lazySingleton<_i904.FavoritesLocalDataSource>(() =>
        _i904.FavoritesLocalDataSourceImpl(gh<_i314.HomeLocalDataSource>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i974.FirebaseFirestore>(),
            ));
    gh.lazySingleton<_i131.FilterRepository>(
        () => _i1033.FilterRepositoryImpl(gh<_i314.HomeLocalDataSource>()));
    gh.lazySingleton<_i963.ProductRepository>(
        () => _i764.ProductRepositoryImpl(gh<_i333.ProductRemoteDataSource>()));
    gh.lazySingleton<_i910.GetAllProducts>(
        () => _i910.GetAllProducts(gh<_i963.ProductRepository>()));
    gh.lazySingleton<_i2.GetCategories>(
        () => _i2.GetCategories(gh<_i963.ProductRepository>()));
    gh.lazySingleton<_i147.GetProductById>(
        () => _i147.GetProductById(gh<_i963.ProductRepository>()));
    gh.factory<_i28.ProductBloc>(() => _i28.ProductBloc(
          gh<_i910.GetAllProducts>(),
          gh<_i2.GetCategories>(),
        ));
    gh.lazySingleton<_i212.FavoritesRepository>(() =>
        _i144.FavoritesRepositoryImpl(gh<_i904.FavoritesLocalDataSource>()));
    gh.lazySingleton<_i0.HomeRepository>(
        () => _i76.HomeRepositoryImpl(gh<_i314.HomeLocalDataSource>()));
    gh.lazySingleton<_i804.OnboardingLocalDataSource>(() =>
        _i804.OnboardingLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i543.OrderRepository>(() => _i376.OrderRepositoryImpl(
          remoteDataSource: gh<_i1007.OrderRemoteDataSource>(),
          localDataSource: gh<_i303.OrderLocalDataSource>(),
        ));
    gh.lazySingleton<_i530.ApplyFilter>(
        () => _i530.ApplyFilter(gh<_i131.FilterRepository>()));
    gh.lazySingleton<_i460.ResetFilter>(
        () => _i460.ResetFilter(gh<_i131.FilterRepository>()));
    gh.lazySingleton<_i868.AddToCart>(
        () => _i868.AddToCart(gh<_i322.CartRepository>()));
    gh.lazySingleton<_i912.GetCart>(
        () => _i912.GetCart(gh<_i322.CartRepository>()));
    gh.factory<_i1006.FilterBloc>(() => _i1006.FilterBloc(
          gh<_i530.ApplyFilter>(),
          gh<_i460.ResetFilter>(),
        ));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i161.AuthRemoteDataSource>()));
    gh.factory<_i418.GetFavorites>(
        () => _i418.GetFavorites(gh<_i212.FavoritesRepository>()));
    gh.factory<_i189.RemoveFavorite>(
        () => _i189.RemoveFavorite(gh<_i212.FavoritesRepository>()));
    gh.lazySingleton<_i159.GetHomeCategories>(
        () => _i159.GetHomeCategories(gh<_i0.HomeRepository>()));
    gh.lazySingleton<_i303.GetHomeProducts>(
        () => _i303.GetHomeProducts(gh<_i0.HomeRepository>()));
    gh.lazySingleton<_i816.SearchHomeProducts>(
        () => _i816.SearchHomeProducts(gh<_i0.HomeRepository>()));
    gh.lazySingleton<_i101.ToggleProductFavorite>(
        () => _i101.ToggleProductFavorite(gh<_i0.HomeRepository>()));
    gh.lazySingleton<_i884.GetHomeFavoriteIds>(
        () => _i884.GetHomeFavoriteIds(gh<_i0.HomeRepository>()));
    gh.lazySingleton<_i430.OnboardingRepository>(() =>
        _i452.OnboardingRepositoryImpl(gh<_i804.OnboardingLocalDataSource>()));
    gh.factory<_i517.CartBloc>(() => _i517.CartBloc(
          gh<_i912.GetCart>(),
          gh<_i868.AddToCart>(),
        ));
    gh.lazySingleton<_i474.CheckOnboardingStatus>(
        () => _i474.CheckOnboardingStatus(gh<_i430.OnboardingRepository>()));
    gh.lazySingleton<_i561.CompleteOnboarding>(
        () => _i561.CompleteOnboarding(gh<_i430.OnboardingRepository>()));
    gh.factory<_i901.UpdateUserProfile>(
        () => _i901.UpdateUserProfile(gh<_i787.AuthRepository>()));
    gh.factory<_i497.WatchAuthChanges>(
        () => _i497.WatchAuthChanges(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i111.GetCurrentUser>(
        () => _i111.GetCurrentUser(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i485.SignInWithEmail>(
        () => _i485.SignInWithEmail(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i568.SignOut>(
        () => _i568.SignOut(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i460.SignUpWithEmail>(
        () => _i460.SignUpWithEmail(gh<_i787.AuthRepository>()));
    gh.factory<_i725.CreateOrder>(
        () => _i725.CreateOrder(gh<_i543.OrderRepository>()));
    gh.factory<_i43.GetOrderById>(
        () => _i43.GetOrderById(gh<_i543.OrderRepository>()));
    gh.factory<_i299.GetUserOrders>(
        () => _i299.GetUserOrders(gh<_i543.OrderRepository>()));
    gh.factory<_i298.OrderBloc>(() => _i298.OrderBloc(
          createOrder: gh<_i725.CreateOrder>(),
          getUserOrders: gh<_i299.GetUserOrders>(),
          getOrderById: gh<_i43.GetOrderById>(),
        ));
    gh.factory<_i792.OnboardingBloc>(
        () => _i792.OnboardingBloc(gh<_i561.CompleteOnboarding>()));
    gh.factory<_i469.ProfileBloc>(() => _i469.ProfileBloc(
          getCurrentUser: gh<_i111.GetCurrentUser>(),
          updateUserProfile: gh<_i901.UpdateUserProfile>(),
          signOut: gh<_i568.SignOut>(),
        ));
    gh.factory<_i302.SplashBloc>(() => _i302.SplashBloc(
          checkOnboardingStatus: gh<_i474.CheckOnboardingStatus>(),
          getCurrentUser: gh<_i111.GetCurrentUser>(),
        ));
    gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc(
          gh<_i303.GetHomeProducts>(),
          gh<_i159.GetHomeCategories>(),
          gh<_i101.ToggleProductFavorite>(),
          gh<_i816.SearchHomeProducts>(),
          gh<_i884.GetHomeFavoriteIds>(),
        ));
    gh.factory<_i429.FavoritesBloc>(() => _i429.FavoritesBloc(
          gh<_i418.GetFavorites>(),
          gh<_i189.RemoveFavorite>(),
        ));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          gh<_i485.SignInWithEmail>(),
          gh<_i460.SignUpWithEmail>(),
          gh<_i568.SignOut>(),
          gh<_i111.GetCurrentUser>(),
          gh<_i497.WatchAuthChanges>(),
        ));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
