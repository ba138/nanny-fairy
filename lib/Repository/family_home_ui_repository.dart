import 'package:flutter/material.dart';
import 'package:nanny_fairy/res/components/widgets/family_home_ui_enums.dart';
import 'package:nanny_fairy/res/components/widgets/family_job_enums.dart';

class FamilyHomeUiRepository extends ChangeNotifier {
  FamilyHomeUiEnums _selectedType = FamilyHomeUiEnums.DefaultSection;
  FamilyJobEnums _selectedFamilyJobType = FamilyJobEnums.DefaultSection;

  FamilyJobEnums get selectedFamilyJobType => _selectedFamilyJobType;
  FamilyHomeUiEnums get selectedType => _selectedType;

  void switchToType(FamilyHomeUiEnums type) {
    _selectedType = type;
    notifyListeners();
  }

  void switchToJobType(FamilyJobEnums type) {
    _selectedFamilyJobType = type;
    notifyListeners();
  }

  void switchToDefaultSection() {
    switchToType(FamilyHomeUiEnums.DefaultSection);
    notifyListeners();
  }

  void switchToJobDefaultSection() {
    switchToJobType(FamilyJobEnums.DefaultSection);
    notifyListeners();
  }
}
