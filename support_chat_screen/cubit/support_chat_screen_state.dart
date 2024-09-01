part of 'support_chat_screen_cubit.dart';

abstract class SupportChatScreenState extends Equatable {
  const SupportChatScreenState();

  @override
  List<Object?> get props => [];
}

class SupportChatScreenLoaded extends SupportChatScreenState {
  final List<MessageEntity>? messagesList;
  final bool? isSendingMsg;

  const SupportChatScreenLoaded({this.messagesList, this.isSendingMsg});

  SupportChatScreenLoaded copyWith(
      {List<MessageEntity>? messagesList, bool? isSendingMsg}) {
    return SupportChatScreenLoaded(
        messagesList: messagesList ?? this.messagesList ?? [],
        isSendingMsg: isSendingMsg ?? this.isSendingMsg ?? false);
  }

  @override
  List<Object?> get props => [messagesList, isSendingMsg];
}

class SupportChatScreenLoading extends SupportChatScreenState {}

class SupportChatScreenError extends SupportChatScreenState {
  final String message;

  const SupportChatScreenError({required this.message});

  @override
  List<Object> get props => [message];
}
