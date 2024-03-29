import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getDownloadsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir!.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: _storedImage != null
                  ? Image.file(
                      _storedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      'No Image Taken',
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Take Picture'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePicture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
