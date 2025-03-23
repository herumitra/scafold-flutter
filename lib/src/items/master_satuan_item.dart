import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../utils/constants.dart';
import '../widgets/forms_widget.dart';
import '../models/unit.dart';
import '../services/unit_service.dart';
import '../datasources/unit_datasource.dart';

class MasterSatuanItem extends StatefulWidget {
  const MasterSatuanItem({super.key});

  @override
  _MasterSatuanItemState createState() => _MasterSatuanItemState();
}

class _MasterSatuanItemState extends State<MasterSatuanItem> {
  late UnitDataSource _unitDataSource;
  late UnitService _unitService;
  List<Unit> _units = [];
  List<Unit> _filteredUnits = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _unitService = UnitService();
    _fetchUnits();
  }

  Future<void> _fetchUnits() async {
    setState(() => _isLoading = true);
    try {
      List<Unit> newData = await _unitService.getUnits();
      _units = newData;
      _filteredUnits = _units;
      _unitDataSource = UnitDataSource(
        units: _filteredUnits,
        onDelete: _deleteUnit,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data kategori supplier");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterUnits(String query) {
    setState(() {
      _filteredUnits =
          query.isEmpty
              ? _units
              : _units
                  .where(
                    (s) => s.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _unitDataSource.updateData(_filteredUnits);
    });
  }

  Future<void> _addUnit(String name) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _unitService.createUnit(name);
      EasyLoading.showSuccess("Unit berhasil ditambahkan!");
      _fetchUnits();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan Unit");
    }
  }

  Future<void> _updateUnit(String id, String name) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _unitService.updateUnit(id, name);
      EasyLoading.showSuccess("Unit berhasil diperbarui!");
      _fetchUnits();
    } catch (e) {
      EasyLoading.showError("Gagal memperbarui unit");
    }
  }

  Future<void> _deleteUnit(String id) async {
    EasyLoading.show(status: 'Menghapus...');
    try {
      await _unitService.deleteUnit(id);
      EasyLoading.showSuccess("Unit berhasil dihapus!");
      _fetchUnits();
    } catch (e) {
      EasyLoading.showError("Gagal menghapus unit");
    }
  }

  void _showForm({Unit? unit}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: unit?.name ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            unit == null ? 'Tambah Unit' : 'Edit Unit',
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
                  FormWidgets.buildTextField("Nama Unit", nameController),
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
                  if (unit == null) {
                    await _addUnit(nameController.text);
                  } else {
                    await _updateUnit(unit.id, nameController.text);
                  }
                }
              },
              child: Text(unit == null ? "Tambah" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER UNIT"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterUnits,
            hintText: "Cari Unit",
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SfDataGrid(
                      source: _unitDataSource,
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
                          columnName: 'actions',
                          label: AppWidgets.buildAppHeader('Aksi'),
                          columnWidthMode: ColumnWidthMode.fill,
                          maximumWidth: 200,
                          minimumWidth: 100,
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
