import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/blocs/search/search_state.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class SearchBarController extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarController({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: anyColorTextStyle,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<FoodSearchBloc>().add(UpdateQuery(value));
              },
            ),
          ),
          BlocBuilder<FoodSearchBloc, FoodSearchState>(
            builder: (context, state) {
              if (state.query.isEmpty) {
                return const SizedBox(width: 0);
              }
              return Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE0B2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<FoodSearchBloc>().add(
                      const UpdateQuery(''),
                    ); // reset search
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
