import 'package:flutter/material.dart';
import 'package:gid/features/domain/entities/message_entity.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/components/support_chat_message_text.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/components/support_message_avatar.dart';

class SupportChatMessage extends StatelessWidget {
  const SupportChatMessage({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: !message.isMe!
          ? [
              SupportMessageAvatar(isSupportMessage: message.isMe!),
              SupportChatMessageText(message: message)
            ]
          : [
              SupportChatMessageText(message: message),
              SupportMessageAvatar(isSupportMessage: !message.isMe!),
            ],
    );
  }
}
