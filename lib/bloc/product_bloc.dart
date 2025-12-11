import 'package:dhanyan/bloc/product_event.dart';
import 'package:dhanyan/bloc/product_state.dart';
import 'package:dhanyan/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository repo;

  PropertyBloc(this.repo) : super(const PropertyState()) {
    // Fetch Properties
    on<FetchPropertiesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final list = await repo.getProperties(page: 1);

        emit(state.copyWith(
          isLoading: false,
          properties: list,
          allProperties: list,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    });

    on<SearchPropertyEvent>((event, emit) {
      final query = event.query.toLowerCase();

      final filtered = state.allProperties.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.location.toLowerCase().contains(query);
      }).toList();

      emit(state.copyWith(properties: filtered));
    });
  }
}
