import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class PropertyDetailScreen extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  property.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const SizedBox(height: 280, child: Icon(Icons.image_not_supported, size: 40)),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.deepPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.type,
                      style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.deepPurple),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: const TextStyle(fontSize: 14, color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "\$${property.price}/month",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Property Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // AREA
                        Column(
                          children: [
                            const Icon(Icons.square_foot, color: Colors.deepPurple, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              "${property.area} sq.ft",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Text("Area",
                                style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                          ],
                        ),

                        // BEDROOMS
                        Column(
                          children: [
                            const Icon(Icons.bed, color: Colors.deepPurple, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              "${property.bedrooms} Beds",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Text("Bedrooms",
                                style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                          ],
                        ),

                        // BATHROOMS
                        Column(
                          children: [
                            const Icon(Icons.bathtub_outlined, color: Colors.deepPurple, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              "${property.bathrooms} Baths",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Text("Bathrooms",
                                style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Property Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "Posted on: ${property.date.day}-${property.date.month}-${property.date.year}",
                        style: const TextStyle(color: Colors.deepPurple, fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Contact Owner",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
