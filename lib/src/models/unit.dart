// Initialize the Unit class
class Unit {
  // Define the properties
  final String id;
  final String name;

  // Constructor
  Unit({required this.id, required this.name});

  // Factory constructor
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(id: json['id'], name: json['name']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
