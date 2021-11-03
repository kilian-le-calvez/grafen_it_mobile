import 'package:grafen_it_mobile_app/urls.dart' as urls;

class Video {
  int id;
  String title;
  String videofile;

  Video({required this.id, required this.title, required this.videofile});

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
        id: map['id'],
        title: map['title'],
        videofile: urls.domain + map['videofile']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'videofile': videofile};
  }
}
