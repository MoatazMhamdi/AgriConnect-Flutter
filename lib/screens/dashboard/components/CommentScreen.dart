import 'package:flutter/material.dart';
import '../../../Services/CommentService.dart';
import '../../../models/comment_model.dart';

class CommentScreen extends StatefulWidget {
  final CommentService commentService;
  final String blogId;

  CommentScreen({CommentService? commentService, required this.blogId}) : commentService = commentService ?? CommentService(apiUrl: 'http://localhost:9090/comments');

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> commentList = [];

  @override
  void initState() {
    super.initState();
    _loadCommentList();
    print(commentList);
  }

  void _loadCommentList() async {
    try {
      commentList = await widget.commentService.getCommentsByBlogId(widget.blogId);
    } catch (e) {
      print('Error loading blog list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: FutureBuilder<List<Comment>>(
        future: widget.commentService.getCommentsByBlogId(widget.blogId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator or placeholder while data is being fetched
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Error handling
            return Text('Error loading comments: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Display message when no comments are available
            return Text('No comments available');
          } else {
            // Data is available, build your UI with the comments
            commentList = snapshot.data!;
            return DataTable(
              columns: [
                DataColumn(label: Text("commentaire")),
                DataColumn(label: Text("Date")),

              ],
              rows: List.generate(
                commentList.length,
                    (index) =>
                    DataRow(
                      cells: [
                        DataCell(Text(commentList[index].text)),
                        DataCell(Text(commentList[index].createdAt.toString())),

                      ],
                    ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add logic to create a new comment
          // For example, use a dialog or a new screen to get user input
          // and call widget.commentService.createComment method
        },
        child: Icon(Icons.add),
      ),
    );
  }

}
