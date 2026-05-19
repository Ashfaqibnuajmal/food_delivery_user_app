import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/shimmer_food_grid.dart';
import 'package:food_user_app/features/chat/logic/controller/chat_controller.dart';
import 'package:food_user_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:food_user_app/features/chat/logic/cubit/chat_state.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_header.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_input_feild.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_message_list.dart';

class ChatAndSupport extends StatelessWidget {
  final String userId;
  const ChatAndSupport({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = ChatController();
    return BlocProvider(
      create: (_) => ChatCubit()..loadUser(userId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: ShimmerLoader(
                    type: ShimmerLayoutType.list,
                    itemCount: 8,
                  ),
                );
              }
              return Column(
                children: [
                  ChatHeader(
                    title: state.userName,
                    subtitle: "Online",
                    onBack: () => Navigator.pop(context),
                  ),

                  ChatMessagesList(
                    userId: userId,
                    messageStream: controller.getMessages(userId),
                    scrollController: controller.scrollController,
                    onDeleteMessage: (messageId) {
                      controller.showDeleteDialog(context, userId, messageId);
                    },
                  ),
                  ChatInputField(
                    controller: controller.messageController,
                    onSend: () => controller.sendMessage(userId),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
