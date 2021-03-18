//
class HomeworkInfo {
  List<dynamic> answers;
  dynamic classroom;
  int classroomId;
  String content;
  int count;
  String createdAt;
  String deadline;
  String files;
  String hashId;
  int id;
  String name;
  dynamic type;
  String updatedAt;

  HomeworkInfo({
    this.answers,
    this.classroom,
    this.classroomId,
    this.content,
    this.count,
    this.createdAt,
    this.deadline,
    this.files,
    this.hashId,
    this.id,
    this.name,
    this.type,
    this.updatedAt,
  });

  factory HomeworkInfo.fromJson(Map<String, dynamic> json) => HomeworkInfo(
        answers: json["answers"],
        classroom: json["classroom"],
        classroomId: json["classroomId"],
        content: json["content"],
        count: json["count"],
        createdAt: json["createdAt"],
        deadline: json["deadline"],
        files: json["files"],
        hashId: json["hashId"],
        id: json["id"],
        name: json["name"],
        type: json["type"],
        updatedAt: json["updatedAt"],
      );
}

class Student {
  List<dynamic> answers;
  String birthday;
  dynamic classroom;
  int classroomId;
  dynamic code;
  String createdAt;
  String fullName;
  int gender;
  int id;
  int parentId;
  String updatedAt;

  Student({
    this.answers,
    this.birthday,
    this.classroom,
    this.classroomId,
    this.code,
    this.createdAt,
    this.fullName,
    this.gender,
    this.id,
    this.parentId,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        answers: json["answers"],
        birthday: json["birthday"],
        classroomId: json["classroomId"],
        classroom: json["classroom"],
        code: json["code"],
        createdAt: json["createdAt"],
        fullName: json["fullName"],
        gender: json["gender"],
        id: json["id"],
        parentId: json["parentId"],
        updatedAt: json["updatedAt"],
      );
}

class HomeworkHashIdInfo {
  Iterable studentObjs;
  Iterable answerHistoryObjs;
  dynamic classroomObj;
  dynamic homeworkObj;
  dynamic answerObj;
  dynamic studentObj;

  HomeworkHashIdInfo(
      {this.answerHistoryObjs,
      this.studentObjs,
      this.studentObj,
      this.homeworkObj,
      this.classroomObj,
      this.answerObj});

  factory HomeworkHashIdInfo.fromJson(Map<String, dynamic> json) =>
      HomeworkHashIdInfo(
        answerHistoryObjs: json["answerHistoryObjs"],
        studentObjs: json["studentObjs"],
        studentObj: json["studentObj"],
        classroomObj: json["classroomObj"],
        homeworkObj: json["homeworkObj"],
        answerObj: json["answerObj"] == null ? {"confirmedAt": null} : json["answerObj"],
      );
}
