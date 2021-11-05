import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/question.dart';
import 'package:grafen_it_mobile_app/snackbar_error.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;

class QuestionWidget extends StatefulWidget {
  final Question question;
  const QuestionWidget({required this.question, Key? key}) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool answering = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteComment() async {
    ApiService()
        .deleteQuestion(urls.deleteQuestion, widget.question.id)
        .then((value) {
      showSnackBarError(context, "Question deleted");
      Navigator.popAndPushNamed(context, '/video');
    }).catchError((onError) {
      showSnackBarError(context, "Could not delete the question sorry");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(widget.question.author),
          Text(widget.question.question),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      answering = !answering;
                    });
                  },
                  icon: answering
                      ? const Icon(Icons.question_answer)
                      : const Icon(Icons.question_answer_outlined)),
              IconButton(
                  onPressed: () {
                    _deleteComment();
                  },
                  icon: const Icon(Icons.delete_forever)),
            ],
          ),
          answering
              ? Row(
                  children: const [
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Answer here'),
                    )),
                  ],
                )
              : const SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }
}
