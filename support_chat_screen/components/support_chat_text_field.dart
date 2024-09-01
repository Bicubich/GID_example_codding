import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gid/constants/paths.dart';
import 'package:gid/constants/size_utils.dart';
import 'package:gid/constants/ui_constants.dart';
import 'package:gid/features/presentation/widgets/custom_loading_indicator.dart';

class SupportChatTextField extends StatelessWidget {
  const SupportChatTextField(
      {super.key,
      required this.controller,
      required this.onSent,
      required this.isSendingMsg});

  final bool isSendingMsg;
  final TextEditingController controller;
  final Function() onSent;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      style: UiConstants.textStyle1
          .copyWith(fontWeight: FontWeight.w400, decorationThickness: 0),
      cursorColor: UiConstants.blackColor,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        filled: true,
        fillColor: UiConstants.whiteColor,
        hintText: 'Text a message...',
        contentPadding: getMarginOrPadding(all: 10),
        hintStyle: UiConstants.textStyle1.copyWith(
            color: UiConstants.greyColor, fontWeight: FontWeight.w400),
        prefixIcon: Padding(
          padding: getMarginOrPadding(right: 8, left: 10),
          child: Transform.rotate(
            angle: 45 * (3.14 / 180), // Переводим градусы в радианы
            child: const Icon(Icons.attach_file),
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: isSendingMsg ? null : onSent,
          child: Padding(
            padding: getMarginOrPadding(right: 8, left: 10),
            child: isSendingMsg
                ? SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: const CustomLoadingIndicator())
                : SvgPicture.asset(Paths.sendMessageIconPath,
                    height: 24.w, width: 24.w, color: UiConstants.darkColor),
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 24.w, minWidth: 24.w),
      ),
    );
  }
}
