import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/global_provider.dart';
import 'package:grafen_it_mobile_app/home_page.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;
import 'package:grafen_it_mobile_app/video.dart';
import 'package:grafen_it_mobile_app/video_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/video': (context) => const VideoPage(),
        },
      ),
    );
  }
}
