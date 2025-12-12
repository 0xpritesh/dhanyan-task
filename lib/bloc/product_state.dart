import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

class ProductState extends Equatable {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasMore;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? hasMore,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, hasMore];
}
