import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geekhub/app.dart';

import 'common/constants.dart';

void main() {
  runZoned(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      // return ErrorPage(
      //     details.exception.toString() + "\n " + details.stack.toString(), details);
    };
    runApp(
        MaterialApp(
          theme: ThemeData(
              primaryColor: Constants.primaryColor,
              scaffoldBackgroundColor: Color.fromRGBO(245, 246, 250, 1),
              visualDensity: VisualDensity.adaptivePlatformDensity
          ),
          home: GeekHubApp(),
        )
    );
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}