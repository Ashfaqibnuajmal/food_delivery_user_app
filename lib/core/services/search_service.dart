import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_bloc.dart';

class SearchService {
  static TextEditingController createSyncedController(BuildContext context) {
    final controller = TextEditingController();

    // Listen to bloc state and update text controller automatically
    context.read<FoodSearchBloc>().stream.listen((state) {
      if (controller.text != state.query) {
        controller.text = state.query;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    });

    return controller;
  }
}
