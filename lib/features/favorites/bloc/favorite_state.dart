import 'package:equatable/equatable.dart';

class FavoriteState extends Equatable {
  final List<Map<String, dynamic>> favorites;
  const FavoriteState({this.favorites = const []});

  FavoriteState copyWith({List<Map<String, dynamic>>? favorites}) {
    return FavoriteState(favorites: favorites ?? this.favorites);
  }

  @override
  List<Object?> get props => [favorites];
}
