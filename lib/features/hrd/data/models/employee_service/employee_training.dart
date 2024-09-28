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
      trainingTitle: json['training_title'],
      trainingDescription: json['training_description'],
      trainingDateTime: json['training_date_time'],
    );
  }
}

class EmployeeTrainingResponse {
  final List<EmployeeTraining> trainings;

  EmployeeTrainingResponse({required this.trainings});

  factory EmployeeTrainingResponse.fromJson(Map<String, dynamic> json) {
    var trainingsList = (json['data'] as List)
        .map((item) => EmployeeTraining.fromJson(item))
        .toList();

    return EmployeeTrainingResponse(trainings: trainingsList);
  }
}
