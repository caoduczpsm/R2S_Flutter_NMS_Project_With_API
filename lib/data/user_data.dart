import 'package:note_management_system_api/data/model_repository.dart';

class UserData extends ModelRepository {

  final Map? info;

  UserData({this.info, int? status, int? error})
      : super(status: status, error: error);

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        info: json['info'],
        status: json['status'],
        error: json['error']);
  }
}
