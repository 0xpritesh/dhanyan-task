import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(product.title), // FIX: title instead of name
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            product.imageUrl.isNotEmpty
                ? product.imageUrl
                : "https://via.placeholder.com/100",
            height: 100,
          ),
          const SizedBox(height: 10),
          Text("Price: ₹${product.price}"),
          Text("Weight: ${product.weight ? "Available" : "Not Available"}"), // FIX
          Text("Date: ${product.date}"),
        ],
      ),
    );
  }
}
