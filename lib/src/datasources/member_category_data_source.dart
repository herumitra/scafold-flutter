import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/member_category.dart';

// initialize the Member Category Data Source
class MemberCategoryDataSource extends DataGridSource {
  MemberCategoryDataSource({
    required List<MemberCategory> memberCategories,
    required this.onEdit,
    required this.onDelete,
  }) {
    _memberCategories =
        memberCategories
            .map<DataGridRow>(
              (memberCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: memberCategory.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: memberCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(memberCategory),
                  ),
                ],
              ),
            )
            .toList();
  }
  Widget _buildActionButtons(MemberCategory memberCategory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => onEdit(memberCategory: memberCategory),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(memberCategory.id),
        ),
      ],
    );
  }

  List<DataGridRow> _memberCategories = [];

  final Function({MemberCategory? memberCategory}) onEdit;
  final Function(int) onDelete;

  void updateData(List<MemberCategory> newMemberCategories) {
    _memberCategories =
        newMemberCategories
            .map<DataGridRow>(
              (memberCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: memberCategory.id),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: memberCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(memberCategory),
                  ),
                ],
              ),
            )
            .toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _memberCategories;

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
