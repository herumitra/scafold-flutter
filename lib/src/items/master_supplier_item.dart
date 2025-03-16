import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';

class MasterSupplierItem extends StatefulWidget {
  const MasterSupplierItem({super.key});

  @override
  _MasterSupplierItemState createState() => _MasterSupplierItemState();
}

class _MasterSupplierItemState extends State<MasterSupplierItem> {
  late SupplierService _supplierService;
  late SupplierDataSource _supplierDataSource;
  List<Supplier> _suppliers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _supplierService = SupplierService();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    setState(() => _isLoading = true);
    try {
      _suppliers = await _supplierService.getSuppliers();
      _supplierDataSource = SupplierDataSource(
        suppliers: _suppliers,
        onDelete: _deleteSupplier,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data supplier");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showForm({Supplier? supplier}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');
    final addressController = TextEditingController(text: supplier?.address ?? '');
    final picController = TextEditingController(text: supplier?.pic ?? '');
    final categoryController = TextEditingController(text: supplier?.supplierCategoryId.toString() ?? '');

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
                  _buildTextField("Alamat", addressController),
                  _buildTextField("PIC", picController),
                  _buildTextField("Kategori ID", categoryController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  if (supplier == null) {
                    await _addSupplier(
                      nameController.text,
                      phoneController.text,
                      addressController.text,
                      picController.text,
                      int.parse(categoryController.text),
                    );
                  } else {
                    await _updateSupplier(
                      supplier.id,
                      nameController.text,
                      phoneController.text,
                      addressController.text,
                      picController.text,
                      int.parse(categoryController.text),
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

  Future<void> _addSupplier(String name, String phone, String address, String pic, int categoryId) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _supplierService.createSupplier(name, phone, address, pic, categoryId);
      EasyLoading.showSuccess("Supplier berhasil ditambahkan!");
      _fetchSuppliers();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan supplier");
    }
  }

  Future<void> _updateSupplier(String id, String name, String phone, String address, String pic, int categoryId) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _supplierService.updateSupplier(id, name, phone, address, pic, categoryId);
      EasyLoading.showSuccess("Supplier berhasil diupdate!");
      _fetchSuppliers();
    } catch (e) {
      EasyLoading.showError("Gagal mengupdate supplier");
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
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Master Supplier"),
      automaticallyImplyLeading: false, // Hilangkan tombol back
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: double.infinity,
                height: 15 * 40, // 10 baris dengan tinggi masing-masing 40px
                child: SfDataGrid(
                  source: _supplierDataSource,
                  columns: [
                    GridColumn(columnName: 'id', label: _buildHeader('ID')),
                    GridColumn(columnName: 'name', label: _buildHeader('Nama')),
                    GridColumn(columnName: 'phone', label: _buildHeader('Telepon')),
                    GridColumn(columnName: 'address', label: _buildHeader('Alamat')),
                    GridColumn(columnName: 'actions', label: _buildHeader('Aksi')),
                  ],
                  rowHeight: 40, // Tinggi setiap baris
                ),
              );
            },
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
      color: Colors.blueGrey,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SupplierDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  final Function(String) onDelete;
  final Function({Supplier? supplier}) onEdit;

  SupplierDataSource({
    required List<Supplier> suppliers,
    required this.onDelete,
    required this.onEdit,
  }) {
    _updateRows(suppliers);
  }

  void _updateRows(List<Supplier> suppliers) {
    _rows = suppliers.map<DataGridRow>((supplier) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: supplier.id),
        DataGridCell<String>(columnName: 'name', value: supplier.name),
        DataGridCell<String>(columnName: 'phone', value: supplier.phone),
        DataGridCell<String>(columnName: 'address', value: supplier.address),
        DataGridCell<Widget>(
          columnName: 'actions',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(supplier: supplier),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(supplier.id),
              ),
            ],
          ),
        ),
      ]);
    }).toList();

    // Tambahkan baris kosong jika kurang dari 10
    while (_rows.length < 10) {
      _rows.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: ''),
        DataGridCell<String>(columnName: 'name', value: ''),
        DataGridCell<String>(columnName: 'phone', value: ''),
        DataGridCell<String>(columnName: 'address', value: ''),
        DataGridCell<Widget>(columnName: 'actions', value: Container()), // Kosong
      ]));
    }

    notifyListeners(); // Update tampilan DataGrid
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'actions') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: dataCell.value, // Menampilkan tombol Edit & Hapus jika ada
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(dataCell.value.toString()),
          );
        }
      }).toList(),
    );
  }
}


