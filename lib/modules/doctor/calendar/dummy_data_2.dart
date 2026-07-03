enum AppointmentType { instant, schedule }

class Appointment {
  final String name;
  final String time;
  final AppointmentType type;
  final String badgeLabel;
  final DateTime date;

  /// 'male' or 'female' — used to show the right avatar
  final String gender;

  const Appointment({
    required this.name,
    required this.time,
    required this.type,
    required this.badgeLabel,
    required this.date,
    this.gender = 'male',
  });
}

class CalendarRange {
  final int start;
  final int end;
  const CalendarRange(this.start, this.end);
}



final List<Appointment> allAppointments = [
  Appointment(
    name: 'Andrew Vijay',
    time: '12:20 PM',
    type: AppointmentType.instant,
    badgeLabel: '4th',
    date: DateTime(2026, 5, 4),
  ),
  Appointment(
    name: 'Vijay',
    time: '12:20 PM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
  ),
  Appointment(
    name: 'Andrew',
    time: '12:20 PM',
    type: AppointmentType.instant,
    badgeLabel: '20th',
    date: DateTime(2026, 5, 20),
  ),
  Appointment(
    name: 'Dr. Kumar',
    time: '10:00 AM',
    type: AppointmentType.schedule,
    badgeLabel: '5th',
    date: DateTime(2026, 5, 5),
  ),
  Appointment(
    name: 'Priya Sharma',
    time: '03:00 PM',
    type: AppointmentType.instant,
    badgeLabel: '18th',
    date: DateTime(2026, 5, 18),
    gender: 'female',
  ),

  // ── More schedule appointments on the same dates ──
  Appointment(
    name: 'Karthik Raja',
    time: '09:30 AM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
  ),
  Appointment(
    name: 'Meena Lakshmi',
    time: '10:15 AM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
    gender: 'female',
  ),
  Appointment(
    name: 'Suresh Kumar',
    time: '11:00 AM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
  ),
  Appointment(
    name: 'Divya Bharathi',
    time: '02:30 PM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
    gender: 'female',
  ),
  Appointment(
    name: 'Arun Prasad',
    time: '11:30 AM',
    type: AppointmentType.schedule,
    badgeLabel: '5th',
    date: DateTime(2026, 5, 5),
  ),
  Appointment(
    name: 'Kavya Reddy',
    time: '04:00 PM',
    type: AppointmentType.schedule,
    badgeLabel: '5th',
    date: DateTime(2026, 5, 5),
    gender: 'female',
  ),
  Appointment(
    name: 'Ramesh Babu',
    time: '09:00 AM',
    type: AppointmentType.schedule,
    badgeLabel: '17th',
    date: DateTime(2026, 5, 17),
  ),
  Appointment(
    name: 'Anitha Selvam',
    time: '12:45 PM',
    type: AppointmentType.schedule,
    badgeLabel: '17th',
    date: DateTime(2026, 5, 17),
    gender: 'female',
  ),
  Appointment(
    name: 'Vignesh Waran',
    time: '10:30 AM',
    type: AppointmentType.schedule,
    badgeLabel: '20th',
    date: DateTime(2026, 5, 20),
  ),
  Appointment(
    name: 'Sneha Priya',
    time: '03:15 PM',
    type: AppointmentType.schedule,
    badgeLabel: '21st',
    date: DateTime(2026, 5, 21),
    gender: 'female',
  ),
];

const List<String> weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];