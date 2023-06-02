import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../data/note_data.dart';
import '../../ultilities/Constant.dart';

class StatusRepository{

  static const int statusCode200 = 200;
  static const int statusCode201 = 201;

  Future<NoteData> getAllStatus(String email) async {
    String url = "${Constant.KEY_STATUS_READ_ALL}$email";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == statusCode200){
      return parseData(response.body);
    }

    throw Exception("Failed to load Status data ${response.statusCode}");
  }

  Future<NoteData> createStatus(String email, String name) async {
    String url =
        "${Constant.KEY_CREATE_STATUS}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> updateStatus(String email, String name, String? nName) async {
    final url = "${Constant.KEY_UPDATE_STATUS}$email&name=$name&nname=$nName";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> deleteStatus(String email, String name) async {
    final url = "${Constant.KEY_DELETE_STATUS}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  NoteData parseData(String response){
    return NoteData.fromJson(json.decode(response));
  }

}