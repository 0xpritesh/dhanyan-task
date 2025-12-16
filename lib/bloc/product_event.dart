import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final bool isRefresh;

  FetchProducts({this.isRefresh = false});
}

class DeleteProduct extends ProductEvent {
  final String id;
  DeleteProduct(this.id);
}