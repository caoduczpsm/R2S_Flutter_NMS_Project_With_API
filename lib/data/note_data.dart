import 'package:note_management_system_api/data/model_repository.dart';

class NoteData extends ModelRepository {
  List<String> dataList;

  NoteData({required this.dataList, int? status, int? error})
      : super(status: status, error: error);

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
        dataList: json['data'],
        status: json['status'],
        error: json['error']);
  }
}
