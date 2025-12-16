import 'package:dhanyan/core/%20pdf_generator.dart';
import 'package:dhanyan/core/price_calculator.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/models/product_model.dart';


class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _makingController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  double gst = 0.0;
  double finalPrice = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _makingController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    final double basePrice = widget.product.price;
    final double makingCharge =
        double.tryParse(_makingController.text) ?? 0.0;
    final double discount =
        double.tryParse(_discountController.text) ?? 0.0;

    gst = PriceCalculator.calculateGST(basePrice);

    finalPrice = PriceCalculator.calculateFinalPrice(
      basePrice: basePrice,
      makingCharge: makingCharge,
      discount: discount,
    );

    setState(() {});
  }

  Future<void> _generatePdf() async {
    final double makingCharge =
        double.tryParse(_makingController.text) ?? 0.0;
    final double discount =
        double.tryParse(_discountController.text) ?? 0.0;

    final file = await PdfGenerator.generateBill(
      product: widget.product,
      gst: gst,
      makingCharge: makingCharge,
      discount: discount,
      finalPrice: finalPrice,
    );

    await Printing.layoutPdf(
      onLayout: (_) => file.readAsBytes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + Back Button
                  Stack(
                    children: [
                      Hero(
                        tag: product.id,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            product.imageUrl.startsWith('http')
                                ? product.imageUrl
                                : 'https://via.placeholder.com/300',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _pad(
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _pad(
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  _pad(
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee),
                        const SizedBox(width: 4),
                        Text(
                          product.price.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  _pad(
                    Text(
                      "Weight: ${product.weight} g",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  _pad(
                    Text(
                      product.weight > 0 ? "Available" : "Out of Stock",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            product.weight > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),

                  _pad(
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          product.date,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 1),

                  // Making Charge
                  _pad(
                    TextField(
                      controller: _makingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Making Charge",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculatePrice(),
                    ),
                  ),

                  // Discount
                  _pad(
                    TextField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Discount",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculatePrice(),
                    ),
                  ),

                  _pad(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GST: ₹${gst.toStringAsFixed(2)}"),
                        const SizedBox(height: 6),
                        Text(
                          "Final Price: ₹${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: finalPrice > 0 ? _generatePdf : null,
                        child: const Text("Submit & Generate Bill"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pad(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}
