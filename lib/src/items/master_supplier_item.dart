import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';
import '../utils/constants.dart';
import '../datasources/supplier_data_source.dart';

class MasterSupplierItem extends StatefulWidget {
  const MasterSupplierItem({super.key});

  @override
  _MasterSupplierItemState createState() => _MasterSupplierItemState();
}

class _MasterSupplierItemState extends State<MasterSupplierItem> {
  late SupplierService _supplierService;
  late SupplierDataSource _supplierDataSource;
  List<Supplier> _suppliers = [];
  List<Supplier> _filteredSuppliers = [];
  List<Map<String, dynamic>> _categories = []; // List kategori dari API
  int? _selectedCategoryId; // ID kategori yang dipilih

  bool _isLoading = true;
  final bool _isFetchingMore = false;
  final int _currentPage = 1;
  final int _itemsPerPage = 20;

  final TextEditingController _searchController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _supplierService = SupplierService();
    _fetchSuppliers();
    _fetchCategories(); // Ambil kategori saat halaman dimuat
  }

  Future<void> _fetchSuppliers() async {
    setState(() => _isLoading = true);
    try {
      List<Supplier> newData = await _supplierService.getSuppliers();
      _suppliers = newData;
      _filteredSuppliers = _suppliers;
      _supplierDataSource = SupplierDataSource(
        suppliers: _filteredSuppliers,
        onDelete: _deleteSupplier,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data supplier");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterSuppliers(String query) {
    setState(() {
      _filteredSuppliers =
          query.isEmpty
              ? _suppliers
              : _suppliers
                  .where(
                    (s) =>
                        s.name.toLowerCase().contains(query.toLowerCase()) ||
                        s.phone.contains(query) ||
                        s.categoryName.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        s.pic.toLowerCase().contains(query.toLowerCase()) ||
                        s.address.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _supplierDataSource.updateData(_filteredSuppliers);
    });
  }

  Future<void> _fetchCategories() async {
  try {
    final newCategories = await _supplierService.getSupplierCategories();
    setState(() {
      // Hilangkan kategori yang duplikat berdasarkan ID
      final uniqueCategories = <int, Map<String, dynamic>>{};
      for (var category in newCategories) {
        uniqueCategories[category["id"]] = category;
      }
      _categories = uniqueCategories.values.toList();
    });
  } catch (e) {
    EasyLoading.showError("Gagal mengambil kategori");
  }
}

  void _showForm({Supplier? supplier}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');
    final addressController = TextEditingController(
      text: supplier?.address ?? '',
    );
    final picController = TextEditingController(text: supplier?.pic ?? '');
    // final categoryController = TextEditingController(
    //   text: supplier?.supplierCategoryId.toString() ?? '',
    // );
    int? selectedCategory = supplier?.supplierCategoryId;

    setState(() {
      _selectedCategoryId = supplier?.supplierCategoryId;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Nama Supplier", nameController),
                  _buildTextField("No. Telepon", phoneController),
                  _buildTextAreaField("Alamat", addressController),
                  _buildTextField("PIC", picController),
                  _buildCategoryDropdown(),
                  // _buildTextField(
                  //   "Kategori ID",
                  //   categoryController,
                  // ), // Tambahkan ini
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ViColors.textDefault,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: ViColors.textDefault,
              ),
              onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                if (supplier == null) {
                  await _addSupplier(
                    nameController.text,
                    phoneController.text,
                    addressController.text,
                    picController.text,
                    _selectedCategoryId!,
                  );
                } else {
                  await _updateSupplier(
                    supplier.id,
                    nameController.text,
                    phoneController.text,
                    addressController.text,
                    picController.text,
                    _selectedCategoryId!,
                  );
                }
              }
            },
              child: Text(supplier == null ? "Tambah" : "Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSupplier(
    String name,
    String phone,
    String address,
    String pic,
    int categoryId,
  ) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _supplierService.createSupplier(
        name,
        phone,
        address,
        pic,
        categoryId,
      );
      EasyLoading.showSuccess("Supplier berhasil ditambahkan!");
      _fetchSuppliers();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan supplier");
    }
  }

  Future<void> _updateSupplier(
    String id,
    String name,
    String phone,
    String address,
    String pic,
    int categoryId,
  ) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _supplierService.updateSupplier(
        id,
        name,
        phone,
        address,
        pic,
        categoryId,
      );
      EasyLoading.showSuccess("Supplier berhasil diperbarui!");
      _fetchSuppliers();
    } catch (e) {
      EasyLoading.showError("Gagal memperbarui supplier");
    }
  }

  Future<void> _deleteSupplier(String id) async {
    EasyLoading.show(status: 'Menghapus...');
    try {
      await _supplierService.deleteSupplier(id);
      EasyLoading.showSuccess("Supplier berhasil dihapus!");
      _fetchSuppliers();
    } catch (e) {
      EasyLoading.showError("Gagal menghapus supplier");
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ViColors.mainDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ViColors.textDefault),
          ),
          labelStyle: const TextStyle(color: ViColors.textDefault),
          hintStyle: const TextStyle(color: ViColors.textDefault),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          alignLabelWithHint: true, // Biar label sejajar dengan teks area
        ),
        validator:
            (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildTextAreaField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ViColors.mainDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ViColors.textDefault),
          ),
          labelStyle: const TextStyle(color: ViColors.textDefault),
          hintStyle: const TextStyle(color: ViColors.textDefault),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          alignLabelWithHint: true, // Biar label sejajar dengan teks area
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null, // Supaya bisa lebih dari satu baris
        minLines: 3, // Tinggi awal 3 baris
        validator:
            (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MASTER SUPPLIER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ViColors.mainDefault,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: ViColors.textDefault),
              controller: _searchController,
              onChanged: _filterSuppliers,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: ViColors.textDefault),
                labelStyle: TextStyle(
                  color: const Color.fromARGB(255, 65, 66, 68),
                ),
                labelText: "Cari Supplier",
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color.fromARGB(255, 65, 66, 68),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ViColors.mainDefault),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SfDataGrid(
                      source: _supplierDataSource,
                      controller: _dataGridController,
                      columns: [
                        GridColumn(
                          columnName: 'id',
                          label: _buildHeader('ID'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'name',
                          label: _buildHeader('Nama'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 75,
                        ),
                        GridColumn(
                          columnName: 'phone',
                          label: _buildHeader('Telepon'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                        ),
                        GridColumn(
                          columnName: 'pic',
                          label: _buildHeader('PIC'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'address',
                          label: _buildHeader('Alamat'),
                          columnWidthMode: ColumnWidthMode.fill,
                        ),
                        GridColumn(
                          columnName: 'category_name',
                          label: _buildHeader('Kategori'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'actions',
                          label: _buildHeader('Aksi'),
                          width: 100,
                        ),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      color: ViColors.mainDefault,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: DropdownButtonFormField<int>(
      value: _selectedCategoryId,
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
      items: _categories.map<DropdownMenuItem<int>>((category) {
        return DropdownMenuItem<int>(
          value: category["id"],
          child: Text(category["name"]),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: "Kategori",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value == null ? "Wajib pilih kategori" : null,
    ),
  );
}

  Widget _buildDropdownField(
  String label,
  List<Map<String, dynamic>> items,
  int? selectedValue,
  ValueChanged<int?> onChanged,
  Supplier? supplier, // Tambahkan parameter supplier
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: DropdownButtonFormField<int>(
      value: _categories.any((cat) => cat["id"] == supplier?.supplierCategoryId)
          ? supplier?.supplierCategoryId
          : null,
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value!; // Gunakan _selectedCategoryId
        });
      },
      items: _categories.map<DropdownMenuItem<int>>((category) {
        return DropdownMenuItem<int>(
          value: category["id"],
          child: Text(category["name"]),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: "Kategori",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value == null ? "Wajib pilih kategori" : null,
    ),
  );
}

}
