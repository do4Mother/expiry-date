import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:expiry/views/home/home.dart';
import 'package:expiry/views/product/add_product/add_product.dart';
import 'package:expiry/views/product/product_detail/product_detail.dart';
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
          )..add(GetListProduct()),
        ),
      ],
      child: const HomeView(),
    ),
  ),
  GoRoute(
    path: ProductDetailView.routeName,
    builder: (context, state) {
      return const ProductDetailView();
    },
  ),
  GoRoute(
    path: AddProductView.routeName,
    builder: (context, state) {
      return const AddProductView();
    },
  ),
]);
