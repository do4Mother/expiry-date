part of 'list_product_bloc.dart';

abstract class ListProductState extends Equatable {
  const ListProductState();

  @override
  List<Object> get props => [];
}

class ListProductInitial extends ListProductState {}

class ListProductLoaded extends ListProductState {
  final List<Product> data;

  const ListProductLoaded({required this.data});
}

class ListProductError extends ListProductState {
  final String message;

  const ListProductError({required this.message});
}
