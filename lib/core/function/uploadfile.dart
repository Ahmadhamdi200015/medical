import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


imageUploadCamera()async{

  final XFile? file =await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
    maxWidth: 150,
  );

// final XFile? file=await ImagePicker().pickImage(source:ImageSource.camera,imageQuality: 90);

  if (file != null) {
    return File(file.path);
  } else {
    return null;
  }
}

fileUploadGallery([isSvg = false]) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions:
          isSvg ? ["svg", "SVG"] : ["png", "PNG", "jpg", "jpeg", "gif"]);

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

showOptionMenuImage(imageUploadCamera, fileUploadGallery) {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: const Text("ADD Image From Camera"),
          trailing: const Icon(Icons.camera_alt_outlined),
          onTap: () {
            imageUploadCamera();
            Get.back();
          },
        ),
        ListTile(
          title: const Text("ADD Image From Gallary"),
          trailing: const Icon(Icons.image_outlined),
          onTap: () {
            fileUploadGallery();
            Get.back();

          },
        )
      ],
    ),
  ));
}
