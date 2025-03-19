class SupplierCategory {
  final int id;
  final String name;
  final String branchId;

  SupplierCategory({
    required this.id,
    required this.name,
    required this.branchId,
  });

  factory SupplierCategory.fromJson(Map<String, dynamic> json) {
    return SupplierCategory(
      id: json['id'], // Pastikan ini int
      name: json['name'] ?? '',
      branchId: json['branch_id'] ?? '',
    );
  }

  @override
  String toString() {
    return 'SupplierCategory(id: $id, name: $name, branchId: $branchId)';
  }
}
