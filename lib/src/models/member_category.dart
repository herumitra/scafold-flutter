// Initialize the Member Category class
class MemberCategory {
  // Define the properties
  final int id;
  final String name;

  // Constructor
  MemberCategory({required this.id, required this.name});

  // Factory constructor
  factory MemberCategory.fromJson(Map<String, dynamic> json) {
    return MemberCategory(id: json['id'], name: json['name']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
