enum AppointmentType { instant, schedule }

class Appointment {
  final String name;
  final String time;
  final AppointmentType type;
  final String badgeLabel;
  final DateTime date;

  const Appointment({
    required this.name,
    required this.time,
    required this.type,
    required this.badgeLabel,
    required this.date,
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
  ),
];

const List<String> weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];