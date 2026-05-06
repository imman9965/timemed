import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecialityDoctorController extends GetxController {
  RxList<Map<String, dynamic>> doctors = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredDoctors = <Map<String, dynamic>>[].obs;

  RxnInt selectedSpecialityId = RxnInt();
  TextEditingController searchCtrl = TextEditingController();
  RxString searchText = ''.obs;

  /// 🔹 Speciality list (WITH ID)
  final List<Map<String, dynamic>> specialities = [
    {"id": 4, "name": "Pediatrics"},
    {"id": 5, "name": "Cardiology"},
    {"id": 6, "name": "Gynecology"},
    {"id": 7, "name": "Dermatology"},
    {"id": 8, "name": "Orthopedics"},
  ];

  @override
  void onInit() {
    super.onInit();

    doctors.value = [
      {
        "name": "Dr. Mariappan",
        "degree": "MBBS",
        "speciality": "Pediatrics",
        "specialityId": 4,
        "experience": "3 Years",
        "fee": "₹550",
        "image": "https://i.pravatar.cc/150?img=3",
      },
      {
        "name": "Dr. Arjun",
        "degree": "MD",
        "speciality": "Cardiology",
        "specialityId": 5,
        "experience": "8 Years",
        "fee": "₹700",
        "image": "https://i.pravatar.cc/150?img=5",
      },
      {
        "name": "Dr. Priya",
        "degree": "MBBS, DGO",
        "speciality": "Gynecology",
        "specialityId": 6,
        "experience": "5 Years",
        "fee": "₹600",
        "image": "https://i.pravatar.cc/150?img=10",
      },
    ];

    filteredDoctors.value = doctors;
  }

  /// 🔥 MAIN FILTER METHOD (single logic)
  void applyFilters() {
    List<Map<String, dynamic>> result = doctors;

    /// 🔹 Speciality filter
    if (selectedSpecialityId.value != null) {
      result = result
          .where((doc) => doc["specialityId"] == selectedSpecialityId.value)
          .toList();
    }

    /// 🔹 Search filter
    if (searchText.value.isNotEmpty) {
      result = result
          .where(
            (doc) =>
                doc["name"].toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ) ||
                doc["speciality"].toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ),
          )
          .toList();
    }

    filteredDoctors.value = result;
  }

  /// 🔹 Select speciality
  void selectSpeciality(int id) {
    selectedSpecialityId.value = id;
    applyFilters();
  }

  /// 🔹 Clear speciality
  void clearSpeciality() {
    selectedSpecialityId.value = null;
    applyFilters();
  }

  /// 🔹 Clear search
  void clearSearch() {
    searchCtrl.clear();
    searchText.value = "";
    applyFilters();
  }
}
