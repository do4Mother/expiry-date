import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:expiry/views/home/bloc/market/market_bloc.dart';
import 'package:expiry/views/home/home.dart';
import 'package:expiry/views/login/cubit/login/login_cubit.dart';
import 'package:expiry/views/login/login.dart';
import 'package:expiry/views/product/add_product/add_product.dart';
import 'package:expiry/views/product/cubit/product/product_cubit.dart';
import 'package:expiry/views/product/edit_product/edit_product.dart';
import 'package:expiry/views/product/product_detail/product_detail.dart';
import 'package:expiry/views/product/product_sell/product_sell.dart';
import 'package:expiry/views/sign-up/cubit/signup/signup_cubit.dart';
import 'package:expiry/views/sign-up/sign-up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: HomeView.routeName,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ListProductBloc(
            profileRepository: RepositoryProvider.of<ProfileRepository>(context),
            productRepository: RepositoryProvider.of<ProductRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => MarketBloc(
            productRepository: context.read<ProductRepository>(),
          ),
        ),
      ],
      child: const HomeView(),
    ),
  ),
  GoRoute(
    path: ProductDetailView.routeName,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => ProductCubit(
          productRepository: context.read<ProductRepository>(),
          storageRepository: context.read<StorageRepository>(),
        )..getProduct(state.params['id'] ?? ''),
        child: const ProductDetailView(),
      );
    },
  ),
  GoRoute(
    path: ProductSellView.routeName,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => ProductCubit(
          productRepository: context.read<ProductRepository>(),
          storageRepository: context.read<StorageRepository>(),
        )..getProduct(state.params['id'] ?? ''),
        child: const ProductSellView(),
      );
    },
  ),
  GoRoute(
    path: AddProductView.routeName,
    builder: (context, state) {
      return BlocProvider<ProductCubit>(
        create: (context) => ProductCubit(
          productRepository: RepositoryProvider.of<ProductRepository>(context),
          storageRepository: RepositoryProvider.of<StorageRepository>(context),
        ),
        child: const AddProductView(),
      );
    },
  ),
  GoRoute(
    path: EditProductView.routeName,
    builder: (context, state) {
      return BlocProvider<ProductCubit>(
        create: (context) => ProductCubit(
          productRepository: RepositoryProvider.of<ProductRepository>(context),
          storageRepository: RepositoryProvider.of<StorageRepository>(context),
        )..getProduct(state.params['id'] ?? ''),
        child: const EditProductView(),
      );
    },
  ),
  GoRoute(
    path: LoginView.routeName,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => LoginCubit(profileRepository: context.read<ProfileRepository>()),
        child: const LoginView(),
      );
    },
  ),
  GoRoute(
    path: SignUpView.routeName,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => SignUpCubit(profileRepository: context.read<ProfileRepository>()),
        child: const SignUpView(),
      );
    },
  ),
]);
