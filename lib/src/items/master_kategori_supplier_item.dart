import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier_category.dart';
import '../services/supplier_category_service.dart';
import '../utils/constants.dart';
import '../datasources/supplier_category_data_source.dart';
import '../widgets/forms_widget.dart';

class MasterKategoriSupplierItem extends StatefulWidget {
  const MasterKategoriSupplierItem({super.key});

  @override
  _MasterKategoriSupplierItemState createState() => _MasterKategoriSupplierItemState();
}

class _MasterKategoriSupplierItemState extends State<MasterKategoriSupplierItem> {
  late SupplierCategoryService _supplierCategoryService;
  late SupplierCategoryDataSource _supplierCategoryDataSource;
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
      List<SupplierCategory> newData = await _supplierCategoryService.getSupplierCategories();
      print("DATA DARI API: $newData"); // Debugging, cek apakah ada data
      _supplierCategories = newData;
      _filteredSupplierCategories = _supplierCategories;
      _supplierCategoryDataSource = SupplierCategoryDataSource(
        supplierCategories: _filteredSupplierCategories,
        onDelete: _deleteSupplierCategory,
        onEdit: _showForm,
      );
    } catch (e) {
      print("ERROR FETCH DATA: $e"); // Debugging
      EasyLoading.showError("Gagal mengambil data kategori supplier");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterSupplierCategories(String query) {
    setState((){
      _filteredSupplierCategories =
          query.isEmpty
              ? _supplierCategories
              : _supplierCategories
                  .where(
                    (s) =>
                        s.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _supplierCategoryDataSource.updateData(_filteredSupplierCategories);
    });
  }

  void _showForm({SupplierCategory? supplierCategory}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: supplierCategory?.name ?? '');
    
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text(
            supplierCategory == null ? 'Tambah Kategori Supplier' : 'Edit Kategori Supplier',
            style: TextStyle(
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
                  FormWidgets.buildTextField("Kategori", nameController)
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
                    await _addSupplierCategory(
                      nameController.text,
                    );
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
      }
    );
  }

  Future<void> _addSupplierCategory(
    String name
  ) async{
    EasyLoading.show(status: 'Menambahkan...');
    try{
      await _supplierCategoryService.createSupplierCategory(
        name
      );
      EasyLoading.showSuccess("Kategori berhasil ditambahkan!");
      _fetchSupplierCategories();
    }catch(e){
      EasyLoading.showError("Gagal menambahkan kategori");
    }
  }

  Future<void> _updateSupplierCategory(
    int id,
    String name
  )async{
    EasyLoading.show(status:"Mengupdate...");
    try{
      await _supplierCategoryService.updateSupplierCategory(id, name);
      EasyLoading.showSuccess("Kategori berhasil diperbarui!");
      _fetchSupplierCategories();
    }catch(e){
      EasyLoading.showError("Kategori gagal diperbarui!");
    }
  }

  Future<void> _deleteSupplierCategory(int id)async{
    EasyLoading.show(status: "Menghapus...");
    try{
      await _supplierCategoryService.deleteSupplierCategory(id);
      EasyLoading.showSuccess("Kategori berhasil dihapus!");
      _fetchSupplierCategories();
    }catch(e){
      EasyLoading.showError("Gagal menghapus kategori");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER KATEGORI SUPPLIER"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterSupplierCategories,
            hintText: "Cari Kategori",
          ),
          Expanded(child: 
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
                          maximumWidth: 160,
                        ),
                        GridColumn(
                          columnName: 'name',
                          label: AppWidgets.buildAppHeader('Nama'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 75,
                        ),
                  ]
                )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
