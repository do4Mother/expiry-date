part of 'product_detail_cubit.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState({this.product});

  final Product? product;

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded({required Product product}) : super(product: product);
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});
}
