class Supplier {
  final String id; // Ubah dari int? ke String
  final String name;
  final String phone;
  final String address;
  final String pic;
  final int supplierCategoryId;
  final String branchId;

  Supplier({
    required this.id, // Ubah dari int? ke String
    required this.name,
    required this.phone,
    required this.address,
    required this.pic,
    required this.supplierCategoryId,
    required this.branchId,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'], // Tidak perlu cast karena sudah String
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      pic: json['pic'],
      supplierCategoryId: json['supplier_category_id'],
      branchId: json['branch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Tambahkan id di sini jika diperlukan
      'name': name,
      'phone': phone,
      'address': address,
      'pic': pic,
      'supplier_category_id': supplierCategoryId,
      'branch_id': branchId,
    };
  }
}
