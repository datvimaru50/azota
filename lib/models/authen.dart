/* 
  * Data model for Authentification
  * Dev name: Vu Quoc Dat
  * 
 */
class User {
  String avatar;
  String birthday;
  dynamic classrooms;
  String createdAt;
  dynamic createdBy;
  String email;
  String emailVerifiedAt;
  String fullName;
  int gender;
  int id;
  dynamic note;
  String password;
  String phone;
  String rememberToken;
  String roles;
  bool status;
  String updatedAt;
  String uploadToken;
  String zaloId;

  User(
      {this.avatar,
      this.birthday,
      this.classrooms,
      this.createdAt,
      this.createdBy,
      this.email,
      this.emailVerifiedAt,
      this.fullName,
      this.gender,
      this.id,
      this.note,
      this.password,
      this.phone,
      this.roles,
      this.status,
      this.updatedAt,
      this.rememberToken,
      this.uploadToken,
      this.zaloId});

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: json["avatar"],
        birthday: json["birthday"],
        classrooms: json["classrooms"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        email: json["email"],
        emailVerifiedAt: json["emailVerifiedAt"],
        fullName: json["fullName"],
        gender: json["gender"],
        id: json["id"],
        note: json["note"],
        password: json["password"],
        phone: json["phone"],
        roles: json["roles"],
        status: json["status"],
        updatedAt: json["updatedAt"],
        rememberToken: json["rememberToken"],
        uploadToken: json["uploadToken"],
        zaloId: json["zaloId"],
      );
}
