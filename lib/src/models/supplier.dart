// Initialize the Supplier class
class Supplier {
  // Define the properties
  final String id;
  final String name;
  final String phone;
  final String address;
  final String pic;
  final String categoryName;
  final int supplierCategoryId;
  final String branchId;

  // Constructor
  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.pic,
    required this.categoryName,
    required this.supplierCategoryId,
    required this.branchId,
  });

  // Factory constructor
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      pic: json['pic'],
      categoryName: json['category_name'],
      supplierCategoryId: json['supplier_category_id'],
      branchId: json['branch_id'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'pic': pic,
      'category_name': categoryName,
      'supplier_category_id': supplierCategoryId,
      'branch_id': branchId,
    };
  }
}
