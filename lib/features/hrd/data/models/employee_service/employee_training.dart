class EmployeeTraining {
  final String trainingTitle;
  final String trainingDescription;
  final String trainingDateTime;

  EmployeeTraining({
    required this.trainingTitle,
    required this.trainingDescription,
    required this.trainingDateTime,
  });

  factory EmployeeTraining.fromJson(Map<String, dynamic> json) {
    return EmployeeTraining(
      trainingTitle: json['training_title'] ?? '', // Default to empty string if missing
      trainingDescription: json['training_description'] ?? '', // Default to empty string if missing
      trainingDateTime: json['training_date_time'] ?? '', // Default to empty string if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'training_title': trainingTitle,
      'training_description': trainingDescription,
      'training_date_time': trainingDateTime,
    };
  }
}

class EmployeeTrainingResponse {
  final List<EmployeeTraining> trainings;

  EmployeeTrainingResponse({required this.trainings});

  factory EmployeeTrainingResponse.fromJson(Map<String, dynamic> json) {
    var trainingsList = (json['data'] as List?)
            ?.map((item) => EmployeeTraining.fromJson(item))
            .toList() ??
        [];

    return EmployeeTrainingResponse(trainings: trainingsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': trainings.map((item) => item.toJson()).toList(),
    };
  }
}
