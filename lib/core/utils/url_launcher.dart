import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher(BuildContext context, String url) async {
  // Ensure the URL has a scheme (http/https or custom)
  if (!url.contains('://')) {
    url = 'https://$url';
  }

  Uri uri = Uri.parse(url);

  // Helper: fallback URLs for known schemes
  String? fallbackUrl;

  if (uri.scheme == 'whatsapp') {
    // WhatsApp fallback to web WhatsApp
    fallbackUrl = url.replaceFirst('whatsapp://', 'https://wa.me/');
  } else if (uri.scheme == 'fb') {
    // Facebook fallback to web Facebook
    fallbackUrl = url.replaceFirst('fb://', 'https://facebook.com/');
  }

  try {
    // Try to launch the URL externally first
    bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (launched) {
      log('✅ Successfully launched externally: $url');
      return;
    }

    log('⚠️ Failed to launch externally: $url');

    // If launching app-specific URL failed and we have a fallback, try fallback
    if (fallbackUrl != null) {
      Uri fallbackUri = Uri.parse(fallbackUrl);
      bool fallbackLaunched = await launchUrl(
        fallbackUri,
        mode: LaunchMode.externalApplication,
      );

      if (fallbackLaunched) {
        log('✅ Successfully launched fallback URL: $fallbackUrl');
        return;
      }

      log('⚠️ Failed to launch fallback URL: $fallbackUrl');
    }

    // Final fallback: launch inside the app (in-app webview)
    bool launchedInApp = await launchUrl(uri, mode: LaunchMode.inAppWebView);

    if (launchedInApp) {
      log('✅ Successfully launched in-app webview: $url');
    } else {
      log('❌ Could not launch link even in-app: $url');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the link.')),
      );
    }
  } catch (e, stackTrace) {
    log('🚨 Error launching $url: $e', stackTrace: stackTrace);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred while opening the link.'),
      ),
    );
  }
}
