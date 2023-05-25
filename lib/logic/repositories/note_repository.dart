import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../data/note_data.dart';
import '../../ultilities/Constant.dart';

class NoteRepository{

  static const int statusCode200 = 200;
  static const int statusCode201 = 201;

  Future<NoteData> getAllNotes() async {
    final uri = Uri.parse(Constant.KEY_NOTE_READ_ALL);
    final response = await http.get(uri);
    if(response.statusCode == statusCode200){
      return parseData(response.body);
    }

    throw Exception("Failed to load Profile data ${response.statusCode}");
  }

  NoteData parseData(String response){
    return NoteData.fromJson(json.decode(response));
  }

}