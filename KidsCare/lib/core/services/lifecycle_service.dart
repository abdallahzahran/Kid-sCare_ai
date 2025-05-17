import 'package:flutter/material.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/services/kids_service.dart';

class LifecycleService with WidgetsBindingObserver {
  static final LifecycleService _instance = LifecycleService._internal();
  factory LifecycleService() => _instance;
  LifecycleService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    WidgetsBinding.instance.addObserver(this);
    await CacheHelper.init();
    await KidsService().loadFromCache();
    _isInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground
        await KidsService().loadFromCache();
        break;
      case AppLifecycleState.paused:
        // App is in background
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        break;
      case AppLifecycleState.detached:
        // App is detached
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
} 