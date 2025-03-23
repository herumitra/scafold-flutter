import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../utils/constants.dart';
import '../widgets/forms_widget.dart';
import '../models/product_category.dart';
import '../services/product_category_service.dart';
import '../datasources/product_category_datasource.dart';

class MasterKategoriProdukItem extends StatefulWidget {
  const MasterKategoriProdukItem({super.key});

  @override
  _MasterKategoriProdukItemState createState() =>
      _MasterKategoriProdukItemState();
}

class _MasterKategoriProdukItemState extends State<MasterKategoriProdukItem> {
  late ProductCategoryDataSource _productCategoryDataSource;
  late ProductCategoryService _productCategoryService;
  List<ProductCategory> _productCategories = [];
  List<ProductCategory> _filteredProductCategories = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _productCategoryService = ProductCategoryService();
    _fetchProductCategories();
  }

  Future<void> _fetchProductCategories() async {
    setState(() => _isLoading = true);
    try {
      List<ProductCategory> newData =
          await _productCategoryService.getProductCategories();
      _productCategories = newData;
      _filteredProductCategories = _productCategories;
      _productCategoryDataSource = ProductCategoryDataSource(
        productCategories: _filteredProductCategories,
        onDelete: _deleteProductCategory,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data kategori product");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterProductCategories(String query) {
    setState(() {
      _filteredProductCategories =
          query.isEmpty
              ? _productCategories
              : _productCategories
                  .where(
                    (s) => s.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _productCategoryDataSource.updateData(_filteredProductCategories);
    });
  }

  Future<void> _addProductCategory(String name) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _productCategoryService.createProductCategory(name);
      EasyLoading.showSuccess("Kategori product berhasil ditambahkan!");
      _fetchProductCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan kategori product");
    }
  }

  Future<void> _updateProductCategory(int id, String name) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _productCategoryService.updateProductCategory(id, name);
      EasyLoading.showSuccess("Kategori product berhasil diperbarui!");
      _fetchProductCategories();
    } catch (e) {
      EasyLoading.showError("Gagal memperbarui kategori product");
    }
  }

  Future<void> _deleteProductCategory(int id) async {
    EasyLoading.show(status: 'Menghapus...');
    try {
      await _productCategoryService.deleteProductCategory(id);
      EasyLoading.showSuccess("Kategori product berhasil dihapus!");
      _fetchProductCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menghapus kategori product");
    }
  }

  void _showForm({ProductCategory? productCategory}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: productCategory?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            productCategory == null
                ? 'Tambah Kategori Product'
                : 'Edit Kategori Product',
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
                  if (productCategory == null) {
                    await _addProductCategory(nameController.text);
                  } else {
                    await _updateProductCategory(
                      productCategory.id,
                      nameController.text,
                    );
                  }
                }
              },
              child: Text(productCategory == null ? "Tambah" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER KATEGORI PRODUCT"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterProductCategories,
            hintText: "Cari Kategori Product",
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SfDataGrid(
                      source: _productCategoryDataSource,
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
