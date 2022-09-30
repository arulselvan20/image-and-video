import 'dart:io';
import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

// class First extends StatefulHookWidget {
//   const First({super.key});

//   @override
//   State<First> createState() => _FirstState();
// }

// class _FirstState extends State<First> {
//   final List<String> _list = <String>[];
//   final TextEditingController _textFieldController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(children: _getItems()),
//       floatingActionButton: FloatingActionButton(
//           onPressed: () => _displayDialog(context),
//           tooltip: 'Add Item',
//           child: Icon(Icons.add)),
//     );
//   }

//   void _addItem(String title) {
//     setState(() {
//       _list.add(title);
//     });
//     _textFieldController.clear();
//   }

//   Widget _buildItem(String title) {
//     return ListTile(title: Text(title));
//   }

//   Future<Future> _displayDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Add a task to your list'),
//             content: TextField(
//               controller: _textFieldController,
//               decoration: const InputDecoration(hintText: 'Enter task here'),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('ADD'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _addItem(_textFieldController.text);
//                 },
//               ),
//               TextButton(
//                 child: const Text('CANCEL'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   List<Widget> _getItems() {
//     final List<Widget> _textWidgets = <Widget>[];
//     for (String title in _list) {
//       _textWidgets.add(_buildItem(title));
//     }
//     return _textWidgets;
//   }
// }

class First extends HookWidget {
  First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<String>> _todoList = useState([]);
    ValueNotifier<bool> _loading = useState(false);
    TextEditingController _textFieldController = useTextEditingController();
    File? _image;
    bool selectVideo = false;

    Future _imgFromCamera() async {
      var image = await ImagePicker()
          .getImage(source: ImageSource.camera, imageQuality: 50);

      _image = File(image!.path);
    }

    Future _imgFromGallery() async {
      var image = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 50);

      _image = File(image!.path);
    }

    Future _videoFromGallery() async {
      var image = await ImagePicker().getVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );

      _image = File(image!.path);
    }

    Future _videoFromCamera() async {
      var image = await ImagePicker().getVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 60),
      );

      _image = File(image!.path);
    }

    _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                color: Colors.blue,
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        title: new Text(
                          (selectVideo) ? 'Video Library' : 'Photo Library',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          if (!selectVideo) _imgFromGallery();
                          if (selectVideo) _videoFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        if (!selectVideo) _imgFromCamera();
                        if (selectVideo) _videoFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    void _addTodoItem(String title) {
      _loading.value = true;
      _todoList.value.add(title);

      _textFieldController.clear();
      _loading.value = false;
    }

    Widget _buildTodoItem(String title) {
      return ListTile(title: Text(title));
    }

    Future<Future> _displayDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add a task to your list'),
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: 'Enter task here'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    _addTodoItem(_textFieldController.text);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                _image = null;
                selectVideo = false;
                _showPicker(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Background Color
              ),
              child: const Text(
                'Select photo',
                style: TextStyle(color: Colors.white),
              ),
              // cardColor: Colors.blue,
            ),
            const Center(
              child: Text(
                'Or',
              ),
            ),
            TextButton(
              onPressed: () {
                _image = null;
                selectVideo = true;
                _showPicker(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Background Color
              ),
              child: const Text(
                'Select Video',
                style: TextStyle(color: Colors.white),
              ),
              // cardColor: Colors.blue,
            ),
            if (_image != null && selectVideo == false)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  width: 200,
                  height: 250,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       image: new FileImage(_image), fit: BoxFit.fill),
                  // ),
                  child: Image.file(_image!),
                ),
              ),
            // if (_image != null && selectVideo == true)
            //   Padding(
            //       padding: const EdgeInsets.only(top: 22.0),
            //       child: VideoWidget(
            //         play: true,
            //         url: _image,
            //       )),
          ],
        ),

        // _loading.value
        //     ? SizedBox()
        //     : Column(
        //         children: List.generate(_todoList.value.length, (index) {
        //         return _buildTodoItem(_todoList.value[index]);
        //       }),

        //       ),

        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context),
            tooltip: 'Add Item',
            child: Icon(Icons.add)),
      ),
    );
  }
}
