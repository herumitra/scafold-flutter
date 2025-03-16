import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/supplier.dart';

class SupplierDataSource extends DataGridSource {
  SupplierDataSource({
    required List<Supplier> suppliers,
    required this.onEdit,
    required this.onDelete,
  }) {
    _suppliers =
        suppliers
            .map<DataGridRow>(
              (supplier) => DataGridRow(
                cells: [
                  DataGridCell<String>(columnName: 'id', value: supplier.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: supplier.name,
                  ),
                  DataGridCell<String>(
                    columnName: 'phone',
                    value: supplier.phone,
                  ),
                  DataGridCell<String>(
                    columnName: 'address',
                    value: supplier.address,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(supplier),
                  ),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _suppliers = [];

  final Function({Supplier? supplier}) onEdit;
  final Function(String) onDelete;

  void updateData(List<Supplier> newSuppliers) {
    _suppliers =
        newSuppliers
            .map<DataGridRow>(
              (supplier) => DataGridRow(
                cells: [
                  DataGridCell<String>(columnName: 'id', value: supplier.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: supplier.name,
                  ),
                  DataGridCell<String>(
                    columnName: 'phone',
                    value: supplier.phone,
                  ),
                  DataGridCell<String>(
                    columnName: 'address',
                    value: supplier.address,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(supplier),
                  ),
                ],
              ),
            )
            .toList();
    notifyListeners();
  }

  Widget _buildActionButtons(Supplier supplier) {
    return Row(
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
    );
  }

  @override
  List<DataGridRow> get rows => _suppliers;

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
