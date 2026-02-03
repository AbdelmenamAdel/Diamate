import 'dart:async';
import 'package:diamate/constant.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/chat/presentation/managers/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/chat_history_drawer.dart';
import 'widgets/chat_not_started.dart';
import 'widgets/chatbot_background.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCubit>()..loadAllSessions(),
      child: const ChatbotContent(),
    );
  }
}

class ChatbotContent extends StatefulWidget {
  const ChatbotContent({super.key});

  @override
  State<ChatbotContent> createState() => _ChatbotContentState();
}

class _ChatbotContentState extends State<ChatbotContent> {
  final TextEditingController _controller = TextEditingController();
  late final RecorderController _recorderController;
  bool _isRecording = false;
  bool _hasText = false;
  Timer? _timer;
  int _recordDuration = 0;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorderController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordDuration++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits((seconds / 60).floor());
    String twoDigitSeconds = twoDigits(seconds % 60);
    return "$minutes:$twoDigitSeconds";
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorderController.checkPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = p.join(
          directory.path,
          'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );

        await _recorderController.record(path: path);

        setState(() {
          _isRecording = true;
          _startTimer();
        });
      } else {
        await Permission.microphone.request();
      }
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorderController.stop();
      _stopTimer();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        if (mounted) {
          context.read<ChatCubit>().sendVoiceMessage(path);
        }
      }
    } catch (e) {
      _stopTimer();
      debugPrint("Error stopping recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messages = state is ChatSuccess ? state.messages : [];
        final sessions = state is ChatSuccess ? state.sessions : [];
        final isTyping = context.read<ChatCubit>().isTyping;

        return Scaffold(
          endDrawer: ChatHistoryDrawer(
            sessions: List.from(sessions),
            onSessionTap: (session) =>
                context.read<ChatCubit>().loadSession(session),
            onNewChat: () => context.read<ChatCubit>().startNewChat(),
          ),
          body: ChatbotBackground(
            trailing: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: Color(0xff2D9CDB),
                    size: 20,
                  ),
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const ChatNotStarted()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: messages.length + (isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < messages.length) {
                              return MessageBubble(message: messages[index]);
                            } else {
                              return const TypingIndicator();
                            }
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (_isRecording)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                _formatDuration(_recordDuration),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: K.sg,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: AudioWaveforms(
                                  size: Size(double.infinity, 30.h),
                                  recorderController: _recorderController,
                                  enableGesture: true,
                                  waveStyle: WaveStyle(
                                    showMiddleLine: false,
                                    waveColor: Colors.pink.shade300,
                                    spacing: 4,
                                    extendWaveform: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Slide to cancel", // Actually just release to send for now, but placeholder for style
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontFamily: K.sg,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextField(
                        controller: _controller,
                        cursorHeight: 24,
                        cursorColor: Colors.grey.shade400,
                        style: const TextStyle(
                          fontFamily: K.sg,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        onSubmitted: (value) {
                          context.read<ChatCubit>().sendMessage(value);
                          _controller.clear();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                            fontFamily: K.sg,
                          ),
                          hintText: _isRecording
                              ? ""
                              : "Tips, Insights, Health Tools...",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _hasText
                                ? IconButton(
                                    onPressed: () {
                                      context.read<ChatCubit>().sendMessage(
                                        _controller.text,
                                      );
                                      _controller.clear();
                                    },
                                    icon: const Icon(
                                      Icons.send_rounded,
                                      color: Color(0xff2D9CDB),
                                    ),
                                  )
                                : GestureDetector(
                                    onLongPress: _startRecording,
                                    onLongPressUp: _stopRecording,
                                    child: CircleAvatar(
                                      radius: 16.r,
                                      backgroundColor: Color(
                                        0xff2D9CDB,
                                      ).withOpacity(0.1),
                                      child: Icon(
                                        _isRecording
                                            ? Icons.mic_rounded
                                            : Icons.mic_none_rounded,
                                        color: _isRecording
                                            ? Colors.pink
                                            : const Color(0xff2D9CDB),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
