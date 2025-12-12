import 'package:dhanyan/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../data/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  int page = 1;

  ProductBloc({required this.repository}) : super(const ProductState()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    if (event.isRefresh) {
      page = 1;
    }

    final newProducts = await repository.fetchProducts(page);

    emit(
      state.copyWith(
        products: event.isRefresh
            ? newProducts
            : [...state.products, ...newProducts],
        hasMore: newProducts.isNotEmpty,
        isLoading: false,
      ),
    );

    if (newProducts.isNotEmpty) page++;


    on<DeleteProduct>((event, emit) {
  final updatedList = List<ProductModel>.from(state.products)
    ..removeWhere((p) => p.id == event.id);

  emit(state.copyWith(products: updatedList));
});

  }
}
