part of 'crud_product_cubit.dart';

abstract class CRUDProductState extends Equatable {
  const CRUDProductState();

  @override
  List<Object> get props => [];
}

class CRUDProductInitial extends CRUDProductState {}

class CRUDProductLoading extends CRUDProductState {}

class CRUDProductLoaded extends CRUDProductState {}

class CRUDProductError extends CRUDProductState {
  final String message;

  const CRUDProductError({required this.message});
}
