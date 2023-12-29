import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class CustomLogger {
  // Private constructor to prevent external instantiation
  CustomLogger._privateConstructor();

  // Static instance of the logger
  static final CustomLogger _instance = CustomLogger._privateConstructor();

  // Singleton accessor
  static CustomLogger get instance => _instance;
  final logger = Logger();

  // Logging configuration (customize as needed)
  String _logFile = 'logs.txt'; // Default log file path
  Level _logLevel = Level.debug; // Default logging level

  // Logging methods
  void debug(String message) {
    // Write debug message to log file
    logger.d('debug logs - $message');
  }

  void info(String message) {
    // Write info message to log file
  }

  // ... other logging methods (warn, error, etc.)
}
