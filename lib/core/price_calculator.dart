class PriceCalculator {
  static const double gstRate = 0.03; // 3% GST

  static double calculateGST(double basePrice) {
    return basePrice * gstRate;
  }

  static double calculateFinalPrice({
    required double basePrice,
    required double makingCharge,
    required double discount,
  }) {
    final gst = calculateGST(basePrice);
    return basePrice + gst + makingCharge - discount;
  }
}
