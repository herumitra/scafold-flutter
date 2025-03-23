import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../utils/constants.dart';
import '../widgets/forms_widget.dart';
import '../models/member_category.dart';
import '../services/member_category_service.dart';
import '../datasources/member_category_datasource.dart';

class MasterKategoriMemberItem extends StatefulWidget {
  const MasterKategoriMemberItem({super.key});

  @override
  _MasterKategoriMemberItemState createState() =>
      _MasterKategoriMemberItemState();
}

class _MasterKategoriMemberItemState extends State<MasterKategoriMemberItem> {
  late MemberCategoryDataSource _memberCategoryDataSource;
  late MemberCategoryService _memberCategoryService;
  List<MemberCategory> _memberCategories = [];
  List<MemberCategory> _filteredMemberCategories = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _memberCategoryService = MemberCategoryService();
    _fetchMemberCategories();
  }

  Future<void> _fetchMemberCategories() async {
    setState(() => _isLoading = true);
    try {
      List<MemberCategory> newData =
          await _memberCategoryService.getMemberCategories();
      _memberCategories = newData;
      _filteredMemberCategories = _memberCategories;
      _memberCategoryDataSource = MemberCategoryDataSource(
        memberCategories: _filteredMemberCategories,
        onDelete: _deleteMemberCategory,
        onEdit: _showForm,
      );
    } catch (e) {
      EasyLoading.showError("Gagal mengambil data kategori member");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterMemberCategories(String query) {
    setState(() {
      _filteredMemberCategories =
          query.isEmpty
              ? _memberCategories
              : _memberCategories
                  .where(
                    (s) => s.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
      _memberCategoryDataSource.updateData(_filteredMemberCategories);
    });
  }

  Future<void> _addMemberCategory(String name) async {
    EasyLoading.show(status: 'Menambahkan...');
    try {
      await _memberCategoryService.createMemberCategory(name);
      EasyLoading.showSuccess("Kategori member berhasil ditambahkan!");
      _fetchMemberCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menambahkan kategori member");
    }
  }

  Future<void> _updateMemberCategory(int id, String name) async {
    EasyLoading.show(status: 'Mengupdate...');
    try {
      await _memberCategoryService.updateMemberCategory(id, name);
      EasyLoading.showSuccess("Kategori member berhasil diperbarui!");
      _fetchMemberCategories();
    } catch (e) {
      EasyLoading.showError("Gagal memperbarui kategori member");
    }
  }

  Future<void> _deleteMemberCategory(int id) async {
    EasyLoading.show(status: 'Menghapus...');
    try {
      await _memberCategoryService.deleteMemberCategory(id);
      EasyLoading.showSuccess("Kategori member berhasil dihapus!");
      _fetchMemberCategories();
    } catch (e) {
      EasyLoading.showError("Gagal menghapus kategori member");
    }
  }

  void _showForm({MemberCategory? memberCategory}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: memberCategory?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            memberCategory == null
                ? 'Tambah Kategori Member'
                : 'Edit Kategori Member',
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
                  if (memberCategory == null) {
                    await _addMemberCategory(nameController.text);
                  } else {
                    await _updateMemberCategory(
                      memberCategory.id,
                      nameController.text,
                    );
                  }
                }
              },
              child: Text(memberCategory == null ? "Tambah" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.buildAppBar("MASTER KATEGORI MEMBER"),
      body: Column(
        children: [
          AppWidgets.buildSearchBar(
            controller: _searchController,
            onChanged: _filterMemberCategories,
            hintText: "Cari Kategori Member",
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SfDataGrid(
                      source: _memberCategoryDataSource,
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
