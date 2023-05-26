import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../data/note_data.dart';
import '../../ultilities/Constant.dart';

class NoteRepository {
  static const int statusCode200 = 200;
  static const int statusCode201 = 201;

  Future<NoteData> getAllData(String email) async {
    String url = "${Constant.KEY_NOTE_READ_ALL}$email";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == statusCode200) {
      return parseData(response.body);
    }

    throw Exception("Failed to load Profile data ${response.statusCode}");
  }

  Future<NoteData> createNote(String email, String name, String priority,
      String category, String status, String planDate) async {
    String url =
        "${Constant.KEY_CREATE_NOTE}$email&name=$name&Priority=$priority&Category=$category&Status=$status&PlanDate=$planDate";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  NoteData parseData(String response) {
    return NoteData.fromJson(json.decode(response));
  }
}
