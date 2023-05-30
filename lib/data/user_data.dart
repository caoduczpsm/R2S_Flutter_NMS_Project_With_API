import 'package:note_management_system_api/data/model_repository.dart';

class UserData extends ModelRepository {

  final Info? info;

  UserData({this.info, int? status, int? error})
      : super(status: status, error: error);

  factory UserData.fromJson(Map<String, dynamic> json) {
    final infoJson = json['info'];
    final status = json['status'];
    final error = json['error'];

    if (infoJson !=null) {
      final info = Info.fromJson(infoJson);
      return UserData(info: info,status: status,error: error);
    } else {
      return UserData(status: status, error: error);
    }


  }
}
class Info {
  final String firstName;
  final String lastName;

  Info({ required this.firstName,  required this.lastName});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      firstName: json['FirstName'],
      lastName: json['LastName'],
    );
  }
}

class User {
  final String email;
  final String password;
  Info? info;

  User ({required this.email, required this.password,this.info});

}