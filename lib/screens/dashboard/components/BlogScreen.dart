import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../../../models/blog_model.dart';
import '../../../Services/CommentService.dart';
import '../../../services/BlogService.dart';
import 'CommentScreen.dart';
import 'CustomTextFieldIcon.dart';

class BlogScreen extends StatefulWidget {
  List<Blog> userList = [];
  final BlogServices blogServices = BlogServices(apiUrl: 'http://localhost:9090/blog');


  @override
  _BlogScreenState createState() => _BlogScreenState();

}

class _BlogScreenState extends State<BlogScreen> {
  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController lieuController;
  late TextEditingController dateController;
  late TextEditingController prixController;
  late TextEditingController _rechercheController;

  late Uint8List uploadedImage;
  List<Blog> blogList = [];
  List<String> selectedBlogIds = [];

  @override
  void initState() {
    super.initState();
    titreController = TextEditingController();
    descriptionController = TextEditingController();
    lieuController = TextEditingController();
    dateController = TextEditingController();
    prixController = TextEditingController();
    _rechercheController = TextEditingController();

    uploadedImage = Uint8List(0);
    _loadBlogList();
    print(blogList);
  }

  void _loadBlogList() async {
    try {
      blogList = await widget.blogServices.fetchBlogList();
      print(blogList);
    } catch (e) {
      print('Error loading blog list: $e');
    }
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
        ),
      ],
    );
  }

  Future<void> _startFilePicker() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImage = reader.result as Uint8List;
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            print("Error occurred while reading the file");
          });
        });

        reader.readAsArrayBuffer(file!);
      }
    });
  }

  Future<void> _pickImage() async {
    _startFilePicker();
  }

  Future<Widget> _loadImage(Uint8List imageBytes) async {
    if (imageBytes.isNotEmpty) {
      return Image.memory(
        imageBytes,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey,
      );
    }
  }

  void _showAddBlogDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Blog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildEditableField('Title', titreController),
              buildEditableField('Description', descriptionController),
              buildEditableField('Lieu', lieuController),
              ElevatedButton(
                child: Text('Choose File'),
                onPressed: _pickImage,
              ),
              buildEditableField('Date', dateController),
              buildEditableField('Price', prixController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (uploadedImage.isNotEmpty) {
                    if (titreController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        lieuController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        prixController.text.isEmpty) {
                      print('Please fill in all fields.');
                      return;
                    }

                    await widget.blogServices.createBlog(
                      titre: titreController.text,
                      description: descriptionController.text,
                      lieu: lieuController.text,
                      imageFile: html.File(
                        [uploadedImage],
                        'image.png',
                        {'type': 'image/png'},
                      ),
                      date: dateController.text,
                      prix: double.tryParse(prixController.text) ?? 0.0,
                    );

                    _loadBlogList();
                    Navigator.pop(context);
                  } else {
                    print('Please pick an image.');
                  }
                } catch (e) {
                  print('Error adding blog: $e');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blog Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              FutureBuilder<Widget>(
                future: _loadImage(uploadedImage),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        snapshot.data ?? Container(),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _showAddBlogDialog,
                          child: Text('Add Blog'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _sortBlogsByPrice();
                          },
                          child: Text('Trier par Prix'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            deleteSelectedBlogs();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Couleur de fond du bouton
                            onPrimary: Colors.white, // Couleur du texte
                            elevation: 5, // Élévation du bouton
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Coins arrondis
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Espacement interne du bouton
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Supprimer les Blogs Sélectionnés'),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        Column(
                          children: [
                            CustomTextFieldIcon(
                              controller: _rechercheController,
                              icon: Icons.search,
                              hintText: "Recherche...",
                              fontSize: 16,
                              height: 70,
                              width: 800,
                              onChanged: (query) {
                                _filterBlogs(query);
                              },
                            ),
                            Container(
                              height: 380,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columnSpacing: 16,
                                  columns: [
                                    DataColumn(label: Text("Title")),
                                    DataColumn(label: Text("Description")),
                                    DataColumn(label: Text("Lieu")),
                                    DataColumn(label: Text("Date")),
                                    DataColumn(label: Text("Price")),
                                    DataColumn(label: SizedBox(width: 150, child: Text("Image"))),
                                    DataColumn(label: Text("Actions")),
                                  ],
                                  rows: List.generate(
                                    blogList.length,
                                        (index) => DataRow(
                                      cells: [
                                        DataCell(Text(blogList[index].titre)),
                                        DataCell(Text(blogList[index].description)),
                                        DataCell(Text(blogList[index].lieu)),
                                        DataCell(Text(blogList[index].date)),
                                        DataCell(Text(blogList[index].prix.toString())),
                                        DataCell(
                                          _loadImageFromUrl(blogList[index].image.toString()),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () async {
                                                  // Logique pour la mise à jour de l'élément
                                                  // Vous pouvez appeler une fonction pour effectuer la mise à jour.
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  try {
                                                    if (index >= 0 && index < blogList.length) {
                                                      String blogId = blogList[index].id;
                                                      print('Deleting blog with ID: $blogId, Type: ${blogId.runtimeType}');
                                                      await widget.blogServices.deleteBlog(blogId).then((_) {
                                                        _loadBlogList();
                                                      });
                                                    } else {
                                                      print('Invalid index: $index');
                                                    }
                                                  } catch (e) {
                                                    print('Error deleting blog: $e');
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.comment),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CommentScreen(
                                                        commentService: CommentService(apiUrl: 'http://localhost:9090'),
                                                        blogId: blogList[index].id,
                                                      ),
                                                    ),
                                                  );
                                                  print(blogList[index].id);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(selectedBlogIds.contains(blogList[index].id) ? Icons.check_box : Icons.check_box_outline_blank),
                                                onPressed: () {
                                                  setState(() {
                                                    if (selectedBlogIds.contains(blogList[index].id)) {
                                                      selectedBlogIds.remove(blogList[index].id);
                                                    } else {
                                                      selectedBlogIds.add(blogList[index].id);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading image');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadImageFromUrl(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 150,
      width: 150,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          height: 150,
          width: 150,
          color: Colors.grey,
        );
      },
    );
  }

  void _filterBlogs(String query) {
    setState(() {
      if (query.isNotEmpty) {
        blogList = blogList.where((blog) {
          final titre = blog.titre.toLowerCase();
          final description = blog.description.toLowerCase();
          final lieu = blog.lieu.toLowerCase();

          final parts = query.toLowerCase().split(' ');

          if (parts.length == 2) {
            final searchQueryTitle = parts[0];
            final searchQueryDescription = parts[1];
            return (titre.startsWith(searchQueryTitle) &&
                description.startsWith(searchQueryDescription)) ||
                (description.startsWith(searchQueryTitle) &&
                    titre.startsWith(searchQueryDescription)) ||
                lieu.startsWith(searchQueryTitle);
          } else if (parts.length == 1) {
            final searchQuery = parts[0];
            return titre.startsWith(searchQuery) ||
                description.startsWith(searchQuery) ||
                lieu.startsWith(searchQuery);
          } else {
            return false;
          }
        }).toList();
      } else {
        _loadBlogList();
      }
    });
  }

  void deleteSelectedBlogs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer les blogs sélectionnés ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Logique pour supprimer les blogs sélectionnés
                for (String blogId in selectedBlogIds) {
                  await widget.blogServices.deleteBlog(blogId);
                }
                _loadBlogList();
                selectedBlogIds.clear();
                Navigator.pop(context);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
  void _sortBlogsByPrice() {
    setState(() {
      blogList.sort((a, b) => a.prix.compareTo(b.prix));
    });
  }


  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    lieuController.dispose();
    dateController.dispose();
    prixController.dispose();
    super.dispose();
  }
}
