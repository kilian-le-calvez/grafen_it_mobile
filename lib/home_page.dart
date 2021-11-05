import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/video.dart';
import 'package:grafen_it_mobile_app/video_widget.dart';
import 'package:grafen_it_mobile_app/snackbar_error.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Video> videos = [];
  String newVideoTitle = "";
  String newVideoDescription = "";
  bool editing = false;

  @override
  void initState() {
    videos = [];
    _retrieveVideos();
    super.initState();
  }

  void _addVideo() async {
    ImagePicker().pickVideo(source: ImageSource.gallery).then((video) {
      ApiService()
          .postVideo(
              urls.createVideo, video, newVideoTitle, newVideoDescription)
          .then((value) {
        Navigator.popAndPushNamed(context, '/');
      }).catchError((onError) {
        showSnackBarError(context, "Can't upload the video");
      });
    }).catchError((onError) {
      showSnackBarError(context, "Can't pick the video");
    });
  }

  Future<void> _retrieveVideos() async {
    ApiService().getVideos(urls.getVideos).then((list) {
      List<Video> newVideos = [];
      for (var element in list) {
        newVideos.add(Video.fromMap(element));
      }
      setState(() {
        videos = newVideos;
      });
    }).catchError((onError) {
      showSnackBarError(context, "Can't retrieve video for now");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.purple.shade400),
                  child: const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "Grafen it",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                editing = !editing;
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1)),
              child: const Text("Add a video"),
            ),
          ),
          editing
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  newVideoTitle = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'File title here'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _addVideo();
                            },
                            icon: const Icon(Icons.add_box_outlined),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 5,
                              onChanged: (value) {
                                setState(() {
                                  newVideoDescription = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'File description here'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                Navigator.popAndPushNamed(context, '/');
                throw ("error");
              },
              child: ListView(
                children: <Widget>[
                  videos.isEmpty
                      ? const Text("There are no videos here...",
                          textAlign: TextAlign.center)
                      : Column(
                          children: <Widget>[
                            for (var video in videos)
                              VideoWidget(
                                video: video,
                              ),
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
