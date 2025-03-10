class Plan {
  String name;
  String description;
  DateTime date;
  String status;
  String priority;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.status = 'pending',
    this.priority = 'Low',
  });
}
