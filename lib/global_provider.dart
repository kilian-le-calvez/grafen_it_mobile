import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/video.dart';

class GlobalProvider with ChangeNotifier {
  Video currentVideo =
      Video(id: 0, title: "title", description: "description", file: "file");
}
