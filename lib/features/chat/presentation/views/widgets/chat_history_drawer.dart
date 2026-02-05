import 'package:diamate/constant.dart';
import 'package:diamate/core/utils/time_ago.dart';
import 'package:diamate/features/chat/data/models/chat_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({
    super.key,
    required this.sessions,
    required this.onSessionTap,
    required this.onNewChat,
    required this.onSessionDelete,
  });

  final List<ChatSession> sessions;
  final Function(ChatSession) onSessionTap;
  final VoidCallback onNewChat;
  final Function(ChatSession) onSessionDelete;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff043978), Color(0xff4EACFF).withOpacity(0.9)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            bottomLeft: Radius.circular(30.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chat History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: K.sg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your previous conversations',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
                        fontFamily: K.sg,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onNewChat();
                  },
                  icon: Icon(Icons.add, color: Color(0xff043978)),
                  label: Text(
                    'New Chat',
                    style: TextStyle(
                      color: Color(0xff043978),
                      fontWeight: FontWeight.w700,
                      fontFamily: K.sg,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onSessionTap(session);
                        },
                        onLongPress: () => onSessionDelete(session),
                        borderRadius: BorderRadius.circular(15.r),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white70,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: K.sg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      TimeAgo.formatWithDate(
                                        session.date,
                                        context,
                                      ),
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12.sp,
                                        fontFamily: K.sg,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
