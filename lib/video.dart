import 'package:grafen_it_mobile_app/urls.dart' as urls;

class Video {
  int id;
  String title;
  String description;
  String file;

  Video(
      {required this.id,
      required this.title,
      required this.description,
      required this.file});

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        file: urls.domain + map['file']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videofile': file
    };
  }
}
