import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geekhub/app.dart';

void main() {
  runZoned(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      // return ErrorPage(
      //     details.exception.toString() + "\n " + details.stack.toString(), details);
    };
    runApp(
      GeekHubApp(),
    );
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}