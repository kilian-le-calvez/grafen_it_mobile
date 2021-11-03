import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;
import 'package:grafen_it_mobile_app/video.dart';
import 'package:grafen_it_mobile_app/video_screen.dart';
import 'package:grafen_it_mobile_app/video_widget.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Video> videos = [];

  @override
  void initState() {
    videos = [];
    _retrieveVideos();
    super.initState();
  }

  void _pickVideo() async {
    ImagePicker().pickVideo(source: ImageSource.gallery).then((video) {
      ApiService()
          .postVideo(urls.retrieveVideosCreateUrl, video, "")
          .then((value) {
        _retrieveVideos();
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  _retrieveVideos() async {
    videos = [];

    final Dio dio = Dio();

    ApiService().getVideos(urls.retrieveVideosUrl).then((list) {
      for (var element in list) {
        videos.add(Video.fromMap(element));
        setState(() {});
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            for (var video in videos)
              VideoWidget(videoLink: video.videofile, videoTitle: video.title),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        FloatingActionButton(
          onPressed: _pickVideo,
          child: const Icon(Icons.add),
        ),
      ]),
    );
  }
}
