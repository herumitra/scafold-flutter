import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier_category.dart';

class SupplierCategoryDataSource extends DataGridSource {
  SupplierCategoryDataSource({
    required List<SupplierCategory> supplierCategories,
    required this.onEdit,
    required this.onDelete,
  }) {
    _supplierCategories =
        supplierCategories
            .map<DataGridRow>(
              (supplierCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: supplierCategory.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: supplierCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(supplierCategory),
                  ),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _supplierCategories = [];

  final Function({SupplierCategory? supplierCategory}) onEdit;
  final Function(int) onDelete;

  void updateData(List<SupplierCategory> newSupplierCategories) {
    _supplierCategories =
        newSupplierCategories
            .map<DataGridRow>(
              (supplierCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: supplierCategory.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: supplierCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(supplierCategory),
                  ),
                ],
              ),
            )
            .toList();
    notifyListeners();
  }

  Widget _buildActionButtons(SupplierCategory supplierCategory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => onEdit(supplierCategory: supplierCategory),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(supplierCategory.id),
        ),
      ],
    );
  }

  @override
  List<DataGridRow> get rows => _supplierCategories;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((dataCell) {
            return dataCell.columnName == 'actions'
                ? dataCell.value
                : Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dataCell.value.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
          }).toList(),
    );
  }
}
