import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/snackbar_error.dart';
import 'package:grafen_it_mobile_app/video.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;

class VideoWidget extends StatefulWidget {
  final Video video;

  const VideoWidget({required this.video, Key? key}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    print(widget.video.file);
    _controller = VideoPlayerController.network(widget.video.file)
      ..initialize().then((_) {
        print("init state");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  Future<void> _deleteVideo(int id) async {
    ApiService().deleteVideo(urls.deleteVideo, id).then((value) {
      showSnackBarError(context, "The video add well been deleted");
      Navigator.popAndPushNamed(context, '/');
    }).catchError((onError) {
      showSnackBarError(context, "Error deleting this video");
    });
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
    );
    final playerWidget = Chewie(
      controller: chewieController,
    );
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  widget.video.title,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
              height: 200,
              child: Row(children: <Widget>[Expanded(child: playerWidget)])),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.video.description,
                style: const TextStyle(
                    color: Colors.black54, fontStyle: FontStyle.italic)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  _deleteVideo(widget.video.id);
                },
                icon: const Icon(Icons.delete),
              ),
              ModalRoute.of(context)?.settings.name != "/video"
                  ? IconButton(
                      onPressed: () {
                        context.read<GlobalProvider>().currentVideo =
                            widget.video;
                        Navigator.pushNamed(context, "/video");
                      },
                      icon: const Icon(Icons.arrow_right_alt))
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
