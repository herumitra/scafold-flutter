// Initialize the Supplier Category class
class SupplierCategory {
  // Define the properties
  final int id;
  final String name;

  // Constructor
  SupplierCategory({required this.id, required this.name});

  // Factory constructor
  factory SupplierCategory.fromJson(Map<String, dynamic> json) {
    return SupplierCategory(id: json['id'], name: json['name']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
