import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:flutter/material.dart';

class EmployeeTrainingCardWidget extends StatelessWidget {
  final List<EmployeeTraining> trainings;

  const EmployeeTrainingCardWidget({Key? key, required this.trainings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trainings.length,
      shrinkWrap: true, // This ensures the list takes only the space it needs
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final training = trainings[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                training.trainingTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                training.trainingDescription,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                training.trainingDateTime,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }
}