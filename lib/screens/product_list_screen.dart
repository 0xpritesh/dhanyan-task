import 'package:dhanyan/bloc/product_bloc.dart';
import 'package:dhanyan/bloc/product_event.dart';
import 'package:dhanyan/bloc/product_state.dart';
import 'package:dhanyan/screens/product_details_screen.dart';
import 'package:dhanyan/widgets/product_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<ProductBloc>().add(FetchProducts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return state.hasMore
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text("No products found"));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.products.length + 1,
            itemBuilder: (context, index) {
              if (index == state.products.length) {
                return state.hasMore
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }

              final product = state.products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: Dismissible(
                  key: Key(product.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return direction == DismissDirection.startToEnd;
                  },
                  onDismissed: (direction) {
                    context.read<ProductBloc>().add(DeleteProduct(product.id));
                  },
                  child: ProductTile(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}