import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gid/core/params/no_param.dart';
import 'package:gid/features/data/models/message_model.dart';
import 'package:gid/features/domain/entities/message_entity.dart';
import 'package:gid/features/domain/usecases/chat/get_all_driver_chats.dart';
import 'package:gid/features/domain/usecases/chat/get_messages.dart';
import 'package:gid/features/domain/usecases/chat/sent_message.dart';
part 'support_chat_screen_state.dart';

class SupportChatScreenCubit extends Cubit<SupportChatScreenState> {
  final int? chatId;
  final GetMessages getMessages;
  final SentMessage sentMessage;
  final GetAllDriverChats getAllDriverChats;
  SupportChatScreenCubit(
      {this.chatId,
      required this.getMessages,
      required this.sentMessage,
      required this.getAllDriverChats})
      : super(SupportChatScreenLoading()) {
    _chatId ??= chatId;
  }

  TextEditingController chatController = TextEditingController();

  int? _chatId;

  Future getAllMessages() async {
    _chatId ??= await getUserChat();
    if (chatId == null) {
      const SupportChatScreenError(message: 'Server Failure');
    }

    final failureOrLoads = await getMessages(_chatId!);

    failureOrLoads.fold(
        (error) =>
            emit(const SupportChatScreenError(message: 'Server Failure')),
        (messagesList) async {
      if (state is SupportChatScreenLoaded) {
        emit((state as SupportChatScreenLoaded)
            .copyWith(messagesList: messagesList, isSendingMsg: false));
      } else {
        emit(SupportChatScreenLoaded(
            messagesList: messagesList, isSendingMsg: false));
      }
    });
  }

  Future<int?> getUserChat() async {
    final failureOrLoads = await getAllDriverChats(NoParams());
    int? chatId;

    failureOrLoads.fold(
        (error) =>
            emit(const SupportChatScreenError(message: 'Server Failure')),
        (userChat) {
      chatId = userChat.id;
    });
    return chatId;
  }

  Future sentMsg(BuildContext context) async {
    if (chatController.text.isEmpty) return;

    emit((state as SupportChatScreenLoaded).copyWith(isSendingMsg: true));
    final failureOrLoads = await sentMessage(
      SentMessageParams(
        id: _chatId!,
        message: MessageModel(text: chatController.text),
      ),
    );
    int? chatId;

    failureOrLoads.fold(
        (error) =>
            emit(const SupportChatScreenError(message: 'Server Failure')),
        (_) async {
      chatController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      await getAllMessages();
    });
    return chatId;
  }
}
