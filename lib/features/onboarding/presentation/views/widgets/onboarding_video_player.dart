import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnboardingVideoPlayer extends StatefulWidget {
  final String? videoPath;
  final VideoPlayerController? controller;

  const OnboardingVideoPlayer({super.key, this.videoPath, this.controller})
    : assert(
        videoPath != null || controller != null,
        'Either videoPath or controller must be provided',
      );

  @override
  State<OnboardingVideoPlayer> createState() => _OnboardingVideoPlayerState();
}

class _OnboardingVideoPlayerState extends State<OnboardingVideoPlayer> {
  VideoPlayerController? _localController;
  late VideoPlayerController _effectiveController;
  bool _isLocal = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _effectiveController = widget.controller!;
      _isLocal = false;
    } else {
      _isLocal = true;
      _localController = VideoPlayerController.asset(widget.videoPath!)
        ..initialize().then((_) {
          if (mounted) setState(() {});
          _localController?.setLooping(true);
          _localController?.setVolume(0.0); // Mute locally initialized video
          _localController?.play();
        });
      _effectiveController = _localController!;
    }
  }

  @override
  void dispose() {
    if (_isLocal) {
      _localController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_effectiveController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: _effectiveController.value.aspectRatio + 0.2,
        child: VideoPlayer(_effectiveController),
      ),
    );
  }
}
