import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';

class MasterSupplierItem extends StatefulWidget {
  const MasterSupplierItem({super.key});

  @override
  _MasterSupplierItemState createState() => _MasterSupplierItemState();
}

class _MasterSupplierItemState extends State<MasterSupplierItem> {
  late SupplierService _supplierService;
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
    final addressController = TextEditingController(
      text: supplier?.address ?? '',
    );
    final picController = TextEditingController(text: supplier?.pic ?? '');
    final categoryController = TextEditingController(
      text: supplier?.supplierCategoryId.toString() ?? '',
    );

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
                  supplier == null
                      ? await _addSupplier(
                        nameController.text,
                        phoneController.text,
                        addressController.text,
                        picController.text,
                        int.parse(categoryController.text),
                      )
                      : await _updateSupplier(
                        supplier.id,
                        nameController.text,
                        phoneController.text,
                        addressController.text,
                        picController.text,
                        int.parse(categoryController.text),
                      );
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
        validator:
            (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Master Supplier")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = _suppliers[index];
                  return Card(
                    child: ListTile(
                      title: Text(supplier.name),
                      subtitle: Text(
                        "Telp: ${supplier.phone}\nAlamat: ${supplier.address}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(supplier: supplier),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSupplier(supplier.id),
                          ),
                        ],
                      ),
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
}
