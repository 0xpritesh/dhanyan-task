class Endpoints {
  static const baseUrl = "https://69392e32c8d59937aa06c656.mockapi.io/list/dhanyan";

  static String products(int page) => "$baseUrl/products?page=$page";
}
