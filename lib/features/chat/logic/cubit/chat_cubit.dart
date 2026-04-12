import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/chat/logic/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());

  /// Load user info (replace your old setState logic)
  Future<void> loadUser(String userId) async {
    try {
      // 🔥 Replace this with your Firebase call
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        state.copyWith(
          userName: "Admin", // or fetched name
          userEmail: "",
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
