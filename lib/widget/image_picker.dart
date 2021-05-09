import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) imagePickFn;
   UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final picker = ImagePicker();
  File _image;
  _pickImage()async{
    final image = await picker.getImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
    setState(() {
      _image=File(image.path);
    });
    widget.imagePickFn(File(image.path));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage:_image!=null? FileImage(_image):null,
        ),
        TextButton.icon(
            
            onPressed: _pickImage,
            icon: Icon(Icons.image,),
            label: Text('Add Image')),
      ],
    );
  }
}
