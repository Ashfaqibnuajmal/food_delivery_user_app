import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();
  @override
  List<Object> get props => [];
}

class GenerateContentEvent extends AiChatEvent {
  final String prompt;
  const GenerateContentEvent(this.prompt);
  @override
  List<Object> get props => [prompt];
}
