import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}


class HomeStateLoaded extends HomeState {
  final List list;

  HomeStateLoaded({required this.list});
}

class HomeStateEmptyList extends HomeState {}
