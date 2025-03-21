import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../utils/constants.dart';
import '../widgets/forms_widget.dart';
import '../models/supplier_category.dart';
import '../services/supplier_category_service.dart';
import '../datasources/supplier_category_data_source.dart';

class MasterKategoriSupplierItem extends StatefulWidget {
  const MasterKategoriSupplierItem({super.key});

  @override
  _MasterKategoriSupplierItemState createState() =>
      _MasterKategoriSupplierItemState();
}

class _MasterKategoriSupplierItemState
    extends State<MasterKategoriSupplierItem> {
  late SupplierCategoryDataSource _supplierCategoryDataSource;
  late SupplierCategoryService _supplierCategoryService;
  List<SupplierCategory> _supplierCategories = [];
  List<SupplierCategory> _filteredSupplierCategories = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _supplierCategoryService = SupplierCategoryService();
    _fetchSupplierCategories();
  }

  Future<void> _fetchSupplierCategories() async {
    setState(() => _isLoading = true);
    try {
      List<SupplierCategory> newData =
          await _supplierCategoryService.getSupplierCategories();
      _supplierCategories = newData;
      _filteredSupplierCategories = _supplierCategories;
      _supplierCategoryDataSource = SupplierCategoryDataSource(
        supplierCategories: _filteredSupplierCategories,
        onDelete: _deleteSupplierCategory,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data kategori supplier");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterSupplierCategories(String query) {
    setState(() {
      _filteredSupplierCategories =
          query.isEmpty
              ? _supplierCategories
              : _supplierCategories
                  .where(
                    (s) => s.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _supplierCategoryDataSource.updateData(_filteredSupplierCategories);
    });
  }

  Future<void> _addSupplierCategory(String name) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _supplierCategoryService.createSupplierCategory(name);
      EasyLoading.showSuccess("Kategori supplier berhasil ditambahkan!");
      _fetchSupplierCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan kategori supplier");
    }
  }

  Future<void> _updateSupplierCategory(int id, String name) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _supplierCategoryService.updateSupplierCategory(id, name);
      EasyLoading.showSuccess("Kategori supplier berhasil diperbarui!");
      _fetchSupplierCategories();
    } catch (e) {
      EasyLoading.showError("Gagal memperbarui kategori supplier");
    }
  }

  Future<void> _deleteSupplierCategory(int id) async {
    EasyLoading.show(status: 'Menghapus...');
    try {
      await _supplierCategoryService.deleteSupplierCategory(id);
      EasyLoading.showSuccess("Kategori supplier berhasil dihapus!");
      _fetchSupplierCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menghapus kategori supplier");
    }
  }

  void _showForm({SupplierCategory? supplierCategory}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: supplierCategory?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            supplierCategory == null
                ? 'Tambah Kategori Supplier'
                : 'Edit Kategori Supplier',
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
                  FormWidgets.buildTextField("Nama Kategori", nameController),
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
                  if (supplierCategory == null) {
                    await _addSupplierCategory(nameController.text);
                  } else {
                    await _updateSupplierCategory(
                      supplierCategory.id,
                      nameController.text,
                    );
                  }
                }
              },
              child: Text(supplierCategory == null ? "Tambah" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER KATEGORI SUPPLIER"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterSupplierCategories,
            hintText: "Cari Kategori Supplier",
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SfDataGrid(
                      source: _supplierCategoryDataSource,
                      controller: _dataGridController,
                      columns: [
                        GridColumn(
                          columnName: 'id',
                          label: AppWidgets.buildAppHeader('ID'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 100,
                        ),
                        GridColumn(
                          columnName: 'name',
                          label: AppWidgets.buildAppHeader('Nama'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 75,
                        ),
                        GridColumn(
                          columnName: 'actions',
                          label: AppWidgets.buildAppHeader('Aksi'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 75,
                        ),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ViColors.mainDefault,
        child: const Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }
}
