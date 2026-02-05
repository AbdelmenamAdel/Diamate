import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'widgets/widgets.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  late VideoPlayerController _videoController;
  int _currentIndex = 0;
  final int _totalPages = 6;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(Assets.introOnboardingVideo)
      ..initialize().then((_) {
        setState(() {}); // Refresh to show video once ready
        _videoController.setLooping(false);
        _videoController.setVolume(0.3); // Mute video sound
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  // ==================== Navigation Methods ====================

  void _nextPage() {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skip() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    context.pushReplacementNamed(AppRoutes.login);
  }

  // Request notification permission (shows iOS system dialog)
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted || status.isDenied || status.isPermanentlyDenied) {
      // Move to next page regardless of user choice
      _nextPage();
    }
  }

  // ==================== Build Method ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            OnboardingHeader(
              currentIndex: _currentIndex,
              totalPages: _totalPages,
              onSkip: _skip,
            ),
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  WelcomeScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onNext: _nextPage,
                    videoController: _videoController,
                  ),
                  TrackingScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onNext: _nextPage,
                  ),
                  AiScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onNext: _nextPage,
                  ),
                  ReportsScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onNext: _nextPage,
                  ),
                  NotificationsScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onEnableNotifications: _requestNotificationPermission,
                  ),
                  GetStartedScreen(
                    currentIndex: _currentIndex,
                    totalPages: _totalPages,
                    onGetStarted: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
