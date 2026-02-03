import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMessageBubble extends StatefulWidget {
  const VoiceMessageBubble({super.key, required this.audioPath});
  final String audioPath;

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late PlayerController _playerController;
  late Stream<PlayerState> _playerStateSubscription;
  bool _isPlaying = false;
  int _duration = 0;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _preparePlayer();
    _playerStateSubscription = _playerController.onPlayerStateChanged;
    _playerStateSubscription.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _playerController.onCompletion.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _preparePlayer() async {
    await _playerController.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: true,
      noOfSamples: 50,
      volume: 1.0,
    );
    // Get duration
    final duration = await _playerController.getDuration();
    if (mounted) {
      setState(() {
        _duration = duration;
      });
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar-like circle for play button
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 45.r,
                  height: 45.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30.r,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Waveform and Duration
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AudioFileWaveforms(
                      size: Size(160.w, 35.h),
                      playerController: _playerController,
                      enableSeekGesture: true,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: Colors.white.withOpacity(0.35),
                        liveWaveColor: Colors.white,
                        spacing: 5,
                        waveThickness: 3,
                        seekLineColor: Colors.white,
                        seekLineThickness: 2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_duration),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11.sp,
                            fontFamily: K.sg,
                          ),
                        ),
                        // Dynamic mic/check icon
                        Icon(
                          Icons.done_all_rounded,
                          size: 16.r,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
