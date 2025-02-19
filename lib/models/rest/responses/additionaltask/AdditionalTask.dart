import 'Task.dart';

class AdditionalTask {
  String? id;
  String? name;
  List<Task>? tasks;

  AdditionalTask({this.id, this.name, this.tasks});

  factory AdditionalTask.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;
    List<Task> tasks = tasksList.map((task) => Task.fromJson(task)).toList();

    return AdditionalTask(
      id: json["id"],
      name: json["name"],
      tasks: tasks,
    );
  }
}