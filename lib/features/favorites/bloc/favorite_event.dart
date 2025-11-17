import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class AddToFavorite extends FavoriteEvent {
  final Map<String, dynamic> item;
  const AddToFavorite(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromFavorite extends FavoriteEvent {
  final String itemId;
  const RemoveFromFavorite(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
}
