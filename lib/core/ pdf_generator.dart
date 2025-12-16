import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/product_model.dart';

class PdfGenerator {
  static const String companyLogoUrl =
      'https://static.vecteezy.com/system/resources/previews/011/144/540/non_2x/jewelry-ring-abstract-logo-template-design-with-luxury-diamonds-or-gems-isolated-on-black-and-white-background-logo-can-be-for-jewelry-brands-and-signs-free-vector.jpg';

  static Future<File> generateBill({
    required ProductModel product,
    required double gst,
    required double makingCharge,
    required double discount,
    required double finalPrice,
  }) async {
    final pdf = pw.Document();

    final double cgst = gst / 2;
    final double sgst = gst / 2;

    // 🔥 Load network logo
    final Uint8List logoBytes = await _loadNetworkImage(companyLogoUrl);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _header(logoBytes),
          pw.SizedBox(height: 16),
          _sellerDetails(),
          pw.SizedBox(height: 16),
          _productTable(product, makingCharge, discount, cgst, sgst),
          pw.SizedBox(height: 16),
          _totalSection(finalPrice),
          pw.SizedBox(height: 24),
          _footer(),
        ],
      )
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Invoice_${product.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<Uint8List> _loadNetworkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load logo image');
    }
  }

  static pw.Widget _header(Uint8List logoBytes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Center(
          child: pw.Image(
            pw.MemoryImage(logoBytes),
            width: 80,
            height: 80,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'JEWELLERY SHOP NAME',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'TAX INVOICE',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Date: ${DateTime.now().toString().substring(0, 10)}',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _sellerDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Seller Details',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Text('Jewellery Shop Address'),
        pw.Text('City, State - Pincode'),
        pw.Text('GSTIN: 29XXXXXXXXXXXX'),
        pw.Text('Phone: 9XXXXXXXXX'),
      ],
    );
  }

  static pw.Widget _productTable(
    ProductModel product,
    double makingCharge,
    double discount,
    double cgst,
    double sgst,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
      },
      children: [
        _tableHeader(),
        _tableRow(
          product.title,
          product.weight.toString(),
          product.price.toStringAsFixed(2),
          makingCharge.toStringAsFixed(2),
          discount.toStringAsFixed(2),
        ),
        _gstRow('CGST (1.5%)', cgst),
        _gstRow('SGST (1.5%)', sgst),
      ],
    );
  }

  static pw.TableRow _tableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        _cell('Product'),
        _cell('Weight'),
        _cell('Base Price'),
        _cell('Making'),
        _cell('Discount'),
      ],
    );
  }

  static pw.TableRow _tableRow(
    String name,
    String weight,
    String price,
    String making,
    String discount,
  ) {
    return pw.TableRow(
      children: [
        _cell(name),
        _cell(weight),
        _cell(price),
        _cell(making),
        _cell(discount),
      ],
    );
  }

  static pw.TableRow _gstRow(String title, double value) {
    return pw.TableRow(
      children: [
        _cell(title),
        _cell(''),
        _cell(''),
        _cell(''),
        _cell(value.toStringAsFixed(2)),
      ],
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  static pw.Widget _totalSection(double total) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Final Payable',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text(
                '₹ ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _footer() {
    return pw.Text(
      'Thank you for your purchase.\nThis is a computer generated invoice.',
      style: const pw.TextStyle(fontSize: 9),
      textAlign: pw.TextAlign.center,
    );
  }
}
