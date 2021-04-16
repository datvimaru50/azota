//
class ClassroomInfo {
  int id;
  int countStudents;
  String createdAt;
  List<dynamic> homeworks;
  String name;
  int showAddStudent;
  bool status;
  dynamic students;
  dynamic teacher;
  int teacherId;
  String updatedAt;

  ClassroomInfo({
    this.id,
    this.countStudents,
    this.createdAt,
    this.homeworks,
    this.name,
    this.showAddStudent,
    this.status,
    this.students,
    this.teacher,
    this.teacherId,
    this.updatedAt,
  });

  factory ClassroomInfo.fromJson(Map<String, dynamic> json) => ClassroomInfo(
    id: json["id"],
    countStudents: json["countStudents"],
    createdAt: json["createdAt"],
    homeworks: json["homeworks"],
    name: json["name"],
    showAddStudent: json["showAddStudent"],
    status: json["status"],
    students: json["students"],
    teacher: json["teacher"],
    teacherId: json["teacherId"],
    updatedAt: json["updatedAt"]
  );
}