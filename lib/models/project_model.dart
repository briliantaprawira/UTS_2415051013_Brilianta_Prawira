class ProjectModel {
  final int? id;
  final String title;
  final String concept;
  final int priority;
  final String status;

  ProjectModel({
    this.id,
    required this.title,
    required this.concept,
    required this.priority,
    this.status = 'Sketsa',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      concept: json['concept'] as String,
      priority: json['priority'] as int,
      status: json['status'] as String? ?? 'Sketsa',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'concept': concept,
      'priority': priority,
      'status': status,
    };
  }
}