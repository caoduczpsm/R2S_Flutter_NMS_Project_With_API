import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../data/note_data.dart';
import '../../ultilities/Constant.dart';

class CategoryRepository{

  static const int statusCode200 = 200;
  static const int statusCode201 = 201;

  Future<NoteData> getAllCategory(String email) async {
    String url = "${Constant.KEY_CATEGORY_READ_ALL}$email";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == statusCode200){
      return parseData(response.body);
    }

    throw Exception("Failed to load Profile data ${response.statusCode}");
  }

  Future<NoteData> createCategory(String email, String name) async {
    String url = "${Constant.KEY_CREATE_CATEGORY}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> updateCategory(String email, String name, String? nName) async {
    final url = "${Constant.KEY_UPDATE_CATEGORY}$email&name=$name&nname=$nName";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  Future<NoteData> deleteCategory(String email, String name) async {
    final url = "${Constant.KEY_DELETE_CATEGORY}$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    return NoteData.fromJson(jsonDecode(response.body));
  }

  NoteData parseData(String response){
    return NoteData.fromJson(json.decode(response));
  }

}