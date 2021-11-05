import 'package:flutter/material.dart';
import 'package:grafen_it_mobile_app/apiservice.dart';
import 'package:grafen_it_mobile_app/global_provider.dart';
import 'package:grafen_it_mobile_app/question_widget.dart';
import 'package:grafen_it_mobile_app/snackbar_error.dart';
import 'package:grafen_it_mobile_app/video.dart';
import 'package:grafen_it_mobile_app/question.dart';
import 'package:grafen_it_mobile_app/video_widget.dart';
import 'package:provider/provider.dart';
import 'package:grafen_it_mobile_app/urls.dart' as urls;

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Question> questions = [];
  String newQuestionAuthor = "";
  String newQuestionContent = "";
  bool asking = false;

  @override
  void initState() {
    questions = [];
    _retrieveComments();
    super.initState();
  }

  Future<void> _addQuestion() async {
    ApiService()
        .postQuestion(urls.createQuestion, newQuestionAuthor,
            newQuestionContent, context.read<GlobalProvider>().currentVideo.id)
        .then((value) {
      showSnackBarError(context, "Your comment has been posted");
    }).catchError((onError) {
      showSnackBarError(context, "Can't post this comment");
    });
  }

  Future<void> _retrieveComments() async {
    ApiService()
        .getQuestions(
            urls.getQuestions, context.read<GlobalProvider>().currentVideo.id)
        .then((list) {
      List<Question> newComments = [];
      for (var element in list) {
        newComments.add(Question.fromMap(element));
      }
      setState(() {
        questions = newComments;
      });
    }).catchError((onError) {
      showSnackBarError(context, "No comments to load...");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: asking
          ? AlertDialog(
              actionsPadding: EdgeInsets.all(0),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("What is you question?"),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                newQuestionAuthor = value;
                              });
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your name here'),
                          ),
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
                                newQuestionContent = value;
                              });
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your question here'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            asking = false;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: () {
                          _addQuestion();
                          Navigator.popAndPushNamed(context, '/video');
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      Navigator.popAndPushNamed(context, '/video');
                      throw ("error");
                    },
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.purple.shade400),
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
                        VideoWidget(
                            video: context.read<GlobalProvider>().currentVideo),
                        questions.isEmpty
                            ? const Text("There are no comments here...",
                                textAlign: TextAlign.center)
                            : Column(
                                children: <Widget>[
                                  for (var question in questions)
                                    QuestionWidget(
                                      question: question,
                                    ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      asking = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1)),
                      child: asking
                          ? const Text("Close")
                          : const Text("Ask a question"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
