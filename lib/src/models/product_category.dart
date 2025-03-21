// Initialize the Product Category class
class ProductCategory {
  // Define the properties
  final int id;
  final String name;

  // Constructor
  ProductCategory({required this.id, required this.name});

  // Factory constructor
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(id: json['id'], name: json['name']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
