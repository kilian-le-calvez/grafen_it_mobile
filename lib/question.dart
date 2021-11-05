import 'package:grafen_it_mobile_app/urls.dart' as urls;

class Question {
  int id;
  int videoId;
  String author;
  String question;

  Question(
      {required this.id,
      required this.videoId,
      required this.author,
      required this.question});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        id: map['id'],
        videoId: map['video_id'],
        author: map['author'],
        question: map['question']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'video_id': videoId,
      'author': author,
      'question': question
    };
  }
}
