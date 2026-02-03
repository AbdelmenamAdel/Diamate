import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/features/chat/data/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:diamate/features/chat/presentation/views/widgets/voice_message_bubble.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser =
        message.type == MessageType.user || message.type == MessageType.voice;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Image.asset(Assets.aiLogo, height: 32.h),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: message.type == MessageType.voice
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(
                        colors: [Color(0xff4EACFF), Color(0xff043978)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomLeft: isUser ? Radius.circular(20.r) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: message.type == MessageType.voice
                  ? VoiceMessageBubble(audioPath: message.audioPath ?? '')
                  : SelectableText(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 14.sp,
                        fontFamily: K.sg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Color(0xff2D9CDB).withOpacity(0.1),
              child: Icon(Icons.person, size: 20.r, color: Color(0xff2D9CDB)),
            ),
          ],
        ],
      ),
    );
  }
}
