import 'package:equatable/equatable.dart';

class AiChatState extends Equatable {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final String loadingStage;
  const AiChatState(
      {this.messages = const [],
      this.isLoading = false,
      this.loadingStage = ""});

  AiChatState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    String? loadingStage,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      loadingStage: loadingStage ?? this.loadingStage,
    );
  }

  @override
  List<Object> get props => [messages, isLoading, loadingStage];
}

class AiChatInitial extends AiChatState {
  const AiChatInitial()
      : super(messages: const [], isLoading: false, loadingStage: "");
}

class AiChatLoading extends AiChatState {
  const AiChatLoading({
    required super.messages,
    super.loadingStage = "Thinking...",
  }) : super(isLoading: true);
}

class AiChatLoaded extends AiChatState {
  const AiChatLoaded({required super.messages})
      : super(isLoading: false, loadingStage: "");
}

class AiChatError extends AiChatState {
  final String error;
  const AiChatError({
    required this.error,
    required super.messages,
  }) : super(isLoading: false, loadingStage: "");
  @override
  List<Object> get props => [messages, isLoading, loadingStage, error];
}
