import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/unit.dart';

// initialize the Supplier Category Data Source
class UnitDataSource extends DataGridSource {
  UnitDataSource({
    required List<Unit> units,
    required this.onEdit,
    required this.onDelete,
  }) {
    _units =
        units
            .map<DataGridRow>(
              (unit) => DataGridRow(
                cells: [
                  DataGridCell<String>(columnName: 'id', value: unit.id),
                  DataGridCell<String>(columnName: 'name', value: unit.name),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(unit),
                  ),
                ],
              ),
            )
            .toList();
  }
  Widget _buildActionButtons(Unit unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => onEdit(unit: unit),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(unit.id),
        ),
      ],
    );
  }

  List<DataGridRow> _units = [];

  final Function({Unit? unit}) onEdit;
  final Function(String) onDelete;

  void updateData(List<Unit> newUnits) {
    _units =
        newUnits
            .map<DataGridRow>(
              (unit) => DataGridRow(
                cells: [
                  DataGridCell<String>(columnName: 'id', value: unit.id),
                  DataGridCell<String>(columnName: 'name', value: unit.name),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(unit),
                  ),
                ],
              ),
            )
            .toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _units;

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
