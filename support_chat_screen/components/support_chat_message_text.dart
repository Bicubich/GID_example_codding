import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gid/constants/size_utils.dart';
import 'package:gid/constants/ui_constants.dart';
import 'package:gid/constants/utils.dart';
import 'package:gid/core/enums.dart';
import 'package:gid/features/domain/entities/message_entity.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/components/triangle_painter.dart';
import 'package:gid/features/presentation/pages/home_screen/cubit/home_screen_cubit.dart';

class SupportChatMessageText extends StatelessWidget {
  const SupportChatMessageText({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    Role role = context.read<HomeScreenCubit>().role;

    return Expanded(
      child: Stack(
        children: [
          Container(
            margin: getMarginOrPadding(
              right: !message.isMe! ? 63.w : 5.w,
              left: !message.isMe! ? 5.w : 63.w,
            ),
            padding: getMarginOrPadding(all: 12),
            decoration: BoxDecoration(
              color: message.isMe!
                  ? UiConstants.violetColor
                  : UiConstants.whiteColor,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.isMe!
                          ? (role == Role.ADMIN ? 'You (support)' : 'You')
                          : (role == Role.ADMIN ? 'Ivan Ivanov' : 'Support'),
                      style: UiConstants.textStyle9.copyWith(
                          color: message.isMe!
                              ? UiConstants.whiteColor
                              : UiConstants.darkColor),
                    ),
                    Text(
                      Utils.formatTime(message.createdAt),
                      style: UiConstants.textStyle11.copyWith(
                          color: message.isMe!
                              ? UiConstants.whiteColor
                              : UiConstants.blackColor),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  message.text,
                  style: UiConstants.textStyle10.copyWith(
                      color: message.isMe!
                          ? UiConstants.whiteColor
                          : UiConstants.blackColor),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: !message.isMe! ? null : 0,
            left: message.isMe! ? null : 0,
            child: SizedBox(
              height: 12.h,
              width: 25.5.w,
              child: CustomPaint(
                painter: TrianglePainter(
                    color: message.isMe!
                        ? UiConstants.violetColor
                        : UiConstants.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
