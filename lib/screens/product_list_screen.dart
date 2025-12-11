
import 'package:dhanyan/bloc/product_bloc.dart';
import 'package:dhanyan/bloc/product_event.dart';
import 'package:dhanyan/bloc/product_state.dart';
import 'package:dhanyan/widgets/product_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String selectedCategory = "House";
  String currentAddress = "Fetching...";
  Position? currentPosition;

  final categories = [
    {"icon": Icons.home_filled, "label": "House"},
    {"icon": Icons.villa, "label": "Villa"},
    {"icon": Icons.church, "label": "Bungalow"},
  ];

  @override
  void initState() {
    super.initState();
    context.read<PropertyBloc>().add(FetchPropertiesEvent());
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        currentAddress = "Enable Location!";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() {
        currentAddress = "Location Denied";
      });
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = pos;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    Placemark place = placemarks.first;

    setState(() {
      currentAddress = "${place.locality}, ${place.country}";
    });
  }

  Widget _categoryItem(Map data) {
    bool selected = selectedCategory == data["label"];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = data["label"];
        });
      },
      child: Column(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(
              data["icon"],
              size: 28,
              color: selected ? Colors.black : Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data["label"],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.deepPurple),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        currentAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: _getUserLocation,
                      child: const Icon(Icons.refresh, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.deepPurple,
                              blurRadius: 5,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: const Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.deepPurple.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            context
                                .read<PropertyBloc>()
                                .add(SearchPropertyEvent(value));
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search property...",
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => _categoryItem(categories[i]),
                  separatorBuilder: (_, _) => const SizedBox(width: 18),
                  itemCount: categories.length,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Text(
                      "Recommended Property",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state.isLoading && state.properties.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.properties.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      return PropertyItemTile(
                          property: state.properties[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
