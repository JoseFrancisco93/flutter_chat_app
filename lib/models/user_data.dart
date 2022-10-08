// ignore_for_file: non_constant_identifier_names
class UserData {
  String idUser;
  String fullName;
  int userAge;
  String userMail;

  UserData({
    required this.idUser,
    required this.fullName,
    required this.userAge,
    required this.userMail,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: json['id_user'],
      fullName: json['full_name'],
      userAge: int.parse(json['user_age']),
      userMail: json['user_mail'],
    );
  }
}