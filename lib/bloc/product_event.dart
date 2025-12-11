import 'package:equatable/equatable.dart';

abstract class PropertyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPropertiesEvent extends PropertyEvent {}

class SearchPropertyEvent extends PropertyEvent {
  final String query;
  SearchPropertyEvent(this.query);

  @override
  List<Object?> get props => [query];
}
