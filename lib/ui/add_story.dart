import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyapp_flutter/repo/repository.dart';

import '../model/model.dart';
import '../utils/utils.dart';
import 'home.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  ImagePicker picker = ImagePicker();
  final repository = Repository();
  File? imagepicker;
  final TextEditingController _descriptionController = TextEditingController();

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  Future<void> _showResultDialog(BuildContext context, String message,
      {bool isError = false}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isError ? Icons.error : Icons.check_circle,
                size: 48, color: isError ? Colors.red : Colors.green),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!isError) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
              if (isError) {
                Navigator.pop(context);
                _descriptionController.text = '';
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  bool isValidImageFile(File file) {
    // Validasi jenis file (hanya gambar berdasarkan ekstensi file)
    final validImageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final fileName = file.path.toLowerCase();
    final hasValidExtension = validImageExtensions.any(fileName.endsWith);
    if (!hasValidExtension) {
      return false;
    }

    // Validasi ukuran file (maksimal 1MB)
    final maxSizeInBytes = 1024 * 1024; // 1MB dalam bytes
    if (file.lengthSync() > maxSizeInBytes) {
      _showToast("The size of image too big");
      return false;
    }

    return true;
  }

  void _postStory() async {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Uploading....."),
          ],
        ),
      ),
    );
    if (_descriptionController.text.isNotEmpty) {
      try {
        final description = _descriptionController.text;
        final selectedImageIsValid = isValidImageFile(imagepicker!);
        if (!selectedImageIsValid) {
          // Tampilkan pesan bahwa gambar tidak valid atau ukuran terlalu besar
          Navigator.pop(context);
          return;
        }
        final story = StoryModel(
            description: description, photo: imagepicker!);
        final response = await repository.postStory(story);
        // Assume postStory returns a Response object
        Navigator.pop(context);
        if (!response.error) {
          // Post successful
          _showResultDialog(context, "Upload Success");
          print('Post Success');
        } else {
          // Post failed
          _showResultDialog(context, response.message, isError: true);
          print('Post failed with status: ${response.message}');
        }
      } catch (e) {
        _showResultDialog(context, e.toString(), isError: true);
        print(e.toString());
      }
    } else {
      _showToast("You must fill the description");
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? images = await picker.pickImage(source: ImageSource.gallery);
      imagepicker = File(images!.path);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? images =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
      imagepicker = File(images!.path);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Story"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              imagepicker == null
                  ? AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.asset(imagePlaceHolder),
                    )
                  : AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.file(
                        imagepicker!,
                      ),
                    ), // Gambar yang dipilih

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _showImageSourceDialog, // Munculkan dialog
                child: Text('Choose the Image'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 10,
                  controller: _descriptionController,
                  style: const TextStyle(color: InputColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 212, 167, 238),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(37)),
                  ),
                ),
              ),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: size.height * 0.080,
                    decoration: BoxDecoration(
                        color: ButtonColor,
                        borderRadius: BorderRadius.circular(37)),
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                          color: White, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () {
                    _postStory();
                  }),
              SizedBox(
                height: size.height * 0.020,
              )
            ],
          ),
        ),
      ),
    );
  }
}
