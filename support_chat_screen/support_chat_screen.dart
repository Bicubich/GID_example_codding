import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gid/constants/size_utils.dart';
import 'package:gid/constants/ui_constants.dart';
import 'package:gid/constants/utils.dart';
import 'package:gid/core/enums.dart';
import 'package:gid/features/presentation/widgets/custom_loading_indicator.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/cubit/support_chat_screen_cubit.dart';
import 'package:gid/features/presentation/widgets/custom_text_error_widget.dart';
import 'package:gid/features/presentation/widgets/gid_driver_appbar.dart';
import 'package:gid/features/presentation/widgets/gid_scaffold_template.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/components/support_chat_message.dart';
import 'package:gid/features/presentation/pages/driver/support_chat_screen/components/support_chat_text_field.dart';
import 'package:gid/features/presentation/pages/home_screen/cubit/home_screen_cubit.dart';
import 'package:gid/locator_service.dart';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key, this.chatId, this.userName});

  final int? chatId;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        HomeScreenCubit cubit = context.read<HomeScreenCubit>();
        return GidScaffoldTemplate(
          appBar: cubit.role == Role.DRIVER ? const GidDriverAppBar() : null,
          body: Expanded(
            child: Padding(
              padding: getMarginOrPadding(left: 16, right: 16, top: 12),
              child: BlocProvider(
                create: (context) => SupportChatScreenCubit(
                    chatId: chatId,
                    getMessages: sl(),
                    sentMessage: sl(),
                    getAllDriverChats: sl())
                  ..getAllMessages(),
                child:
                    BlocBuilder<SupportChatScreenCubit, SupportChatScreenState>(
                  builder: (context, state) {
                    SupportChatScreenCubit chatCubit =
                        context.read<SupportChatScreenCubit>();

                    if (state is SupportChatScreenLoading) {
                      return const CustomLoadingIndicator();
                    } else if (state is SupportChatScreenError) {
                      return CustomTextErrorWidget(textError: state.message);
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent));

                    SupportChatScreenLoaded _state =
                        (state as SupportChatScreenLoaded);

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cubit.role != Role.ADMIN
                                  ? 'Support chat'
                                  : userName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  //TextStyle(
                                  //    color: UiConstants.darkColor,
                                  //    fontWeight: FontWeight.w900,
                                  //    fontSize: 24.sp,
                                  //    fontFamily: 'Poppins')
                                  UiConstants.textStyle2.copyWith(
                                      color: UiConstants.darkColor,
                                      fontWeight: FontWeight.w900),
                            ),
                            SizedBox(height: 16.h),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ListView.separated(
                                  padding: getMarginOrPadding(bottom: 96),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final currentMessage =
                                        _state.messagesList![index];

                                    DateTime? previousMessageTime;
                                    if (index > 0) {
                                      previousMessageTime = _state
                                          .messagesList![index - 1].createdAt;
                                    }

                                    final currentMessageTime =
                                        currentMessage.createdAt;

                                    bool shouldShowDate = false;

                                    if (previousMessageTime != null) {
                                      // Проверяем, меняется ли день между предыдущим и текущим сообщением
                                      if (previousMessageTime.day !=
                                              currentMessageTime!.day ||
                                          previousMessageTime.month !=
                                              currentMessageTime.month ||
                                          previousMessageTime.year !=
                                              currentMessageTime.year) {
                                        shouldShowDate = true;
                                      }
                                    } else {
                                      shouldShowDate =
                                          true; // Если это первое сообщение
                                    }
                                    return Column(
                                      children: [
                                        if (shouldShowDate)
                                          Padding(
                                            padding:
                                                getMarginOrPadding(bottom: 23),
                                            child: Text(
                                              Utils.formatDateMMMMd(
                                                  currentMessageTime!),
                                              style: UiConstants.textStyle9
                                                  .copyWith(
                                                      color:
                                                          UiConstants.greyColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ),
                                        SupportChatMessage(
                                          message: _state.messagesList![index],
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 16.h),
                                  itemCount: _state.messagesList!.length,
                                  controller: scrollController,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: SupportChatTextField(
                              isSendingMsg: _state.isSendingMsg!,
                              onSent: () => chatCubit.sentMsg(context),
                              controller: chatCubit.chatController),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
