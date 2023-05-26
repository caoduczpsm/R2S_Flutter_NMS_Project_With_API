import 'model_repository.dart';

class NoteData extends ModelRepository {
  List<dynamic>? data;

  NoteData({required this.data, int? status, int? error})
      : super(status: status, error: error);

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
        status: json['status'],
        error: json['error'],
        data: json['data']);
  }
}
