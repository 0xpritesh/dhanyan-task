import 'package:dhanyan/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

class PropertyState extends Equatable {
  final bool isLoading;
  final List<PropertyModel> properties;       
  final List<PropertyModel> allProperties;    
  final String error;

  const PropertyState({
    this.isLoading = false,
    this.properties = const [],
    this.allProperties = const [],
    this.error = "",
  });

  PropertyState copyWith({
    bool? isLoading,
    List<PropertyModel>? properties,
    List<PropertyModel>? allProperties,
    String? error,
  }) {
    return PropertyState(
      isLoading: isLoading ?? this.isLoading,
      properties: properties ?? this.properties,
      allProperties: allProperties ?? this.allProperties,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, properties, allProperties, error];
}
