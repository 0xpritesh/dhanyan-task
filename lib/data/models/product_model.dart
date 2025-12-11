class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final String location;
  final double price;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final DateTime date;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.location,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.date,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      area: double.tryParse(json['area'].toString()) ?? 0.0,
      bedrooms: int.tryParse(json['bedrooms'].toString()) ?? 0,
      bathrooms: int.tryParse(json['bathrooms'].toString()) ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "type": type,
      "location": location,
      "price": price,
      "area": area,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "date": date.toIso8601String(),
    };
  }
}
