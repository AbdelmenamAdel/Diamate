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
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        Assets.introOnboardingVideo,
      );

      // Add error listener
      _videoController.addListener(() {
        if (_videoController.value.hasError) {
          if (mounted) {
            setState(() {
              _hasVideoError = true;
            });
          }
        }
      });

      await _videoController.initialize();

      if (mounted && !_hasVideoError) {
        setState(() {});
        _videoController.setLooping(false);
        _videoController.setVolume(0.3);
        _videoController.play();
      }
    } catch (e) {
      // Video initialization failed
      if (mounted) {
        setState(() {
          _hasVideoError = true;
        });
      }
    }
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

    if (status.isGranted || status.isLimited || status.isProvisional) {
      // Permission granted, move to next page
      _nextPage();
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open settings
      _showPermissionDialog(
        title: 'Notification Permission Required',
        message:
            'Notifications are permanently denied. Please enable them in Settings to receive important health reminders.',
        isPermanentlyDenied: true,
      );
    } else if (status.isDenied) {
      // Show dialog to request again
      _showPermissionDialog(
        title: 'Enable Notifications',
        message:
            'Stay on track with your health goals! Enable notifications to receive timely reminders for meals, medications, and glucose checks.',
        isPermanentlyDenied: false,
      );
    }
  }

  // Show permission dialog
  Future<void> _showPermissionDialog({
    required String title,
    required String message,
    required bool isPermanentlyDenied,
  }) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.notifications_active_rounded,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              _nextPage(); // Skip and continue
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              if (isPermanentlyDenied) {
                // Open app settings
                await openAppSettings();
                _nextPage();
              } else {
                // Request permission again
                await _requestNotificationPermission();
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isPermanentlyDenied ? 'Open Settings' : 'Enable'),
          ),
        ],
      ),
    );
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
                    hasVideoError: _hasVideoError,
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
