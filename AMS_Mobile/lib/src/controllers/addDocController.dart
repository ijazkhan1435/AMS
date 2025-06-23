import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AddDocController extends GetxController {
  check() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
    }
  }

  static const String uploadUrl = 'YOUR_UPLOAD_ENDPOINT_URL';

  Future<String?> uploadDocument() async {
    try {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (filePickerResult != null) {
        final fileBytes =
            File(filePickerResult.files.single.path!).readAsBytesSync();
        final String fileName = filePickerResult.files.single.name;

        final response = await http.post(
          Uri.parse(uploadUrl),
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          body: {
            'file': base64Encode(fileBytes),
            'name': fileName,
          },
        );

        if (response.statusCode == 200) {
          return json.decode(response.body)[
              'url'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadDocument2() async {
    final url = await uploadDocument();
    if (url != null) {
    } else {
    }
  }
}
