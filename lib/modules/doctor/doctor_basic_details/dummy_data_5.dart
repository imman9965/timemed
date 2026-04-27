import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';



// ════════════════════════════════════════════════════════
//  APP DIMENSIONS
// ════════════════════════════════════════════════════════

class AppDimens1 {
  static const xs  = 4.0;
  static const s   = 8.0;
  static const m   = 12.0;
  static const l   = 16.0;
  static const xl  = 20.0;
  static const xxl = 24.0;
  static const radiusMd       = 10.0;
  static const inputHeight    = 46.0;
  static const screenHPadding = 20.0;
}



class AppTextStyles {
  static final sectionLabel = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark3);
  static final inputHint = TextStyle(
      fontSize: 14, color: AppColors.textMuted3);
  static final inputText = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark3);
  static final chipLabel = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white);
}

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

enum Gender { male, female, others }

class DropdownOption {
  final String value;
  final String label;
  const DropdownOption({required this.value, required this.label});
}

class DoctorFormData {
  String       firstName      = '';
  String       lastName       = '';
  DateTime?    dateOfBirth;
  Gender       gender         = Gender.male;
  String       mobile         = '';
  String       email          = '';
  int          experience     = 0;
  String?      qualification;
  List<String> specialisations = ['Dental', 'Cardiology'];
  String?      category;
  List<String> languages      = ['Tamil'];
  String       address        = '';
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

const List<Gender> genderOptions = [
  Gender.male, Gender.female, Gender.others,
];

const List<DropdownOption> qualificationOptions = [
  DropdownOption(value: 'mbbs', label: 'MBBS'),
  DropdownOption(value: 'bds',  label: 'BDS'),
  DropdownOption(value: 'md',   label: 'MD'),
  DropdownOption(value: 'ms',   label: 'MS'),
  DropdownOption(value: 'bams', label: 'BAMS'),
  DropdownOption(value: 'bhms', label: 'BHMS'),
];

const List<DropdownOption> categoryOptions = [
  DropdownOption(value: 'allergist',         label: 'Allergist'),
  DropdownOption(value: 'anesthesiologist',  label: 'Anesthesiologist'),
  DropdownOption(value: 'audiologist',       label: 'Audiologist'),
  DropdownOption(value: 'cardiologist',      label: 'Cardiologist'),
  DropdownOption(value: 'dermatologist',     label: 'Dermatologist'),
  DropdownOption(value: 'endocrinologist',   label: 'Endocrinologist'),
  DropdownOption(value: 'neurologist',       label: 'Neurologist'),
  DropdownOption(value: 'pediatrician',      label: 'Pediatrician'),
];

const List<String> specialisationSuggestions = [
  'Dental','Cardiology','Neurology','Orthopedics',
  'Pediatrics','Dermatology','Ophthalmology','ENT',
  'Gynecology','Pulmonology','Psychiatry','Radiology',
];

const List<DropdownOption> languageOptions = [
  DropdownOption(value: 'tamil',     label: 'Tamil'),
  DropdownOption(value: 'english',   label: 'English'),
  DropdownOption(value: 'hindi',     label: 'Hindi'),
  DropdownOption(value: 'telugu',    label: 'Telugu'),
  DropdownOption(value: 'kannada',   label: 'Kannada'),
  DropdownOption(value: 'malayalam', label: 'Malayalam'),
];

const List<String> addressSuggestions = [
  'Chennai, Tamilnadu',
  'Coimbatore, Tamilnadu',
  'Madurai, Tamilnadu',
  'Bangalore, Karnataka',
  'Mumbai, Maharashtra',
  'Delhi, India',
  'Hyderabad, Telangana',
];