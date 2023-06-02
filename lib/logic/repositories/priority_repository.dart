import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../data/note_data.dart';
import '../../ultilities/Constant.dart';

class PriorityRepository{

  static const int statusCode200 = 200;
  static const int statusCode201 = 201;

  Future<NoteData> getAllPriority(String email) async {
    String url = "${Constant.KEY_PRIORITY_READ_ALL}$email";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == statusCode200){
      return parseData(response.body);
    }

    throw Exception("Failed to load Priority data ${response.statusCode}");
  }

  Future<NoteData> createPriority(String email, String name) async {
    String url =
        "${Constant.KEY_CREATE_PRIORITY}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> updatePriority(String email, String name, String? nName) async {
    final url = "${Constant.KEY_UPDATE_PRIORITY}$email&name=$name&nname=$nName";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> deletePriority(String email, String name) async {
    final url = "${Constant.KEY_DELETE_PRIORITY}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  NoteData parseData(String response){
    return NoteData.fromJson(json.decode(response));
  }

}