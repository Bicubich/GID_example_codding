import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gid/constants/paths.dart';
import 'package:gid/constants/ui_constants.dart';

class SupportMessageAvatar extends StatelessWidget {
  const SupportMessageAvatar({super.key, this.isSupportMessage = false});

  final bool isSupportMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.w,
      width: 34.w,
      decoration: BoxDecoration(
        color: isSupportMessage ? UiConstants.violetColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: isSupportMessage
          ? Align(
              alignment: Alignment.center,
              child: Text(
                'S',
                style: UiConstants.textStyle10.copyWith(
                    color: UiConstants.whiteColor, fontWeight: FontWeight.w700),
              ),
            )
          : Image.asset(Paths.supportUserAvatarPath, fit: BoxFit.cover),
    );
  }
}
