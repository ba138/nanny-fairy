import 'package:flutter/material.dart';
import 'package:nanny_fairy/res/components/widgets/job_enum.dart';
import 'package:nanny_fairy/res/components/widgets/ui_enums.dart';

class HomeUiSwithchRepository extends ChangeNotifier {
  UIType _selectedType = UIType.DefaultSection;
  JobUIType _selectedJobType = JobUIType.DefaultSection;

  JobUIType get selectedJobType => _selectedJobType;
  UIType get selectedType => _selectedType;

  void switchToType(UIType type) {
    _selectedType = type;
    notifyListeners();
  }

  void switchToJobType(JobUIType type) {
    _selectedJobType = type;
    notifyListeners();
  }

  void switchToDefaultSection() {
    switchToType(UIType.DefaultSection);
    notifyListeners();
  }

  void switchToJobDefaultSection() {
    switchToJobType(JobUIType.DefaultSection);
    notifyListeners();
  }
}
