import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final _dio = Dio();

  ApiService();

  Future<List<dynamic>> getVideos(String url) async {
    _dio.options.contentType = "application/json";
    return _dio.get(url).then((response) {
      return response.data as List<dynamic>;
    }).catchError((onError) {
      throw onError;
    });
  }

  Future<void> postVideo(String url, XFile? file, String title) async {
    String defaultVideoTitle = "avideo";
    String extensionFile = "." + (file!.path).split('.').last;
    String newTitle = title == "" ? defaultVideoTitle : title;
    _dio.options.contentType = "multipart/form-data";

    var formData = FormData.fromMap({
      "title": newTitle,
      "videofile": await MultipartFile.fromFile(file.path,
          filename: newTitle + extensionFile)
    });
    return _dio.post(url, data: formData).then((value) {
      print("IT IS OK");
    }).catchError((onError) {
      throw (onError);
    });
  }
}
