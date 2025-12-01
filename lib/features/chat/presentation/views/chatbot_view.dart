import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'widgets/chat_not_started.dart';
import 'widgets/chatbot_background.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatbotBackground(
        child: Column(
          children: [
            ChatNotStarted(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                cursorHeight: 32,
                cursorColor: Colors.grey.shade300,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(.5),
                    fontWeight: FontWeight.w700,
                    fontFamily: K.sg,
                  ),
                  hintText: "“Tips, Insights, Health Tools…”",
                  suffixIcon: FittedBox(
                    child: IconButton.outlined(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        size: 20,
                        color: Color(0xff2D9CDB),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
