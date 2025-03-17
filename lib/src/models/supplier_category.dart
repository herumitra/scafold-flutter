class SupplierCategory {
  final String id;
  final String name;
  final String branchId;

  SupplierCategory({
    required this.id,
    required this.name,
    required this.branchId,
  });

  factory SupplierCategory.fromJson(Map<String, dynamic> json) {
    return SupplierCategory(
      id: json['id'],
      name: json['name'],
      branchId: json['branch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_id': branchId,
    };
  }
}
