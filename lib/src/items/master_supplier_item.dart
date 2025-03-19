import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';
import '../utils/constants.dart';
import '../datasources/supplier_data_source.dart';
import '../widgets/forms_widget.dart';

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

    setState(() {
      _selectedCategoryId = supplier?.supplierCategoryId;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            supplier == null ? 'Tambah Supplier' : 'Edit Supplier',
            style: TextStyle(
              // color: ViColors.textDefault,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormWidgets.buildTextField("Nama Supplier", nameController),
                  FormWidgets.buildTextField("No. Telepon", phoneController),
                  FormWidgets.buildTextAreaField("Alamat", addressController),
                  FormWidgets.buildTextField("PIC", picController),
                  FormWidgets.buildCustomDropdown(
                    selectedValue: _selectedCategoryId,
                    options: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validatorMessage: "Silahkan pilih kategori",
                    CustomLabelText: "Kategori",
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER SUPPLIER"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterSuppliers,
            hintText: "Cari Supplier",
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
                          label: AppWidgets.buildAppHeader('ID'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'name',
                          label: AppWidgets.buildAppHeader('Nama'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 75,
                        ),
                        GridColumn(
                          columnName: 'phone',
                          label: AppWidgets.buildAppHeader('Telepon'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                        ),
                        GridColumn(
                          columnName: 'pic',
                          label: AppWidgets.buildAppHeader('PIC'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'address',
                          label: AppWidgets.buildAppHeader('Alamat'),
                          columnWidthMode: ColumnWidthMode.fill,
                        ),
                        GridColumn(
                          columnName: 'category_name',
                          label: AppWidgets.buildAppHeader('Kategori'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'actions',
                          label: AppWidgets.buildAppHeader('Aksi'),
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
}
