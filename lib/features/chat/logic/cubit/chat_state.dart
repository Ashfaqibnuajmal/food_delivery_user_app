class ChatState {
  final String userName;
  final String userEmail;
  final bool isLoading;

  ChatState({
    required this.userName,
    required this.userEmail,
    required this.isLoading,
  });

  factory ChatState.initial() {
    return ChatState(userName: "Admin", userEmail: "", isLoading: true);
  }

  ChatState copyWith({String? userName, String? userEmail, bool? isLoading}) {
    return ChatState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
