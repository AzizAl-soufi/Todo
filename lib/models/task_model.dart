class TaskModel {
  int id;
  String title, date, time;
  bool? status;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.status,
  });
}
