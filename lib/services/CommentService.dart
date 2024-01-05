import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/comment_model.dart';

class CommentService {
  final String apiUrl;
  final _blogStreamController = StreamController<List<Comment>>.broadcast();
  List<Comment> _commentList = [];

  CommentService({required this.apiUrl});

  Future<Comment> createComment(String text, String blogId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/comments'),
      body: jsonEncode({'text': text, 'blogId': blogId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final dynamic json = jsonDecode(response.body);
      return Comment.fromJson(json);
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<List<Comment>> getCommentsByBlogId(String blogId) async {
    final response = await http.get(Uri.parse('$apiUrl/comments/$blogId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      print(jsonList.map((json) => Comment.fromJson(json)).toList());

      _commentList= jsonList.map((item) => Comment.fromJson(item)).toList();
      _notifyListeners();

      return _commentList;
    } else {
      throw Exception('Failed to load comments');
    }
  }
  Stream<List<Comment>> get blogStream => _blogStreamController.stream;
  List<Comment> get commentList => _commentList;

  void _notifyListeners() {
    _blogStreamController.add(_commentList);
  }

  void dispose() {
    _blogStreamController.close();
  }

  void setBlogList(List<Comment> blogList) {
    _commentList = blogList;
    _notifyListeners();
  }


  Future<Comment> updateComment(String commentId, String text) async {
    final response = await http.put(
      Uri.parse('$apiUrl/comments/$commentId'),
      body: jsonEncode({'text': text}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(response.body);
      return Comment.fromJson(json);
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<Comment> deleteComment(String commentId) async {
    final response = await http.delete(Uri.parse('$apiUrl/comments/$commentId'));

    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(response.body);
      return Comment.fromJson(json);
    } else {
      throw Exception('Failed to delete comment');
    }
  }
}

