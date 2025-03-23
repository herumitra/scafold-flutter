import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/product_category.dart';

// initialize the Product Category Data Source
class ProductCategoryDataSource extends DataGridSource {
  ProductCategoryDataSource({
    required List<ProductCategory> productCategories,
    required this.onEdit,
    required this.onDelete,
  }) {
    _productCategories =
        productCategories
            .map<DataGridRow>(
              (productCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(
                    columnName: 'id',
                    value: productCategory.id,
                  ),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: productCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(productCategory),
                  ),
                ],
              ),
            )
            .toList();
  }
  Widget _buildActionButtons(ProductCategory productCategory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => onEdit(productCategory: productCategory),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(productCategory.id),
        ),
      ],
    );
  }

  List<DataGridRow> _productCategories = [];

  final Function({ProductCategory? productCategory}) onEdit;
  final Function(int) onDelete;

  void updateData(List<ProductCategory> newProductCategories) {
    _productCategories =
        newProductCategories
            .map<DataGridRow>(
              (productCategory) => DataGridRow(
                cells: [
                  DataGridCell<int>(
                    columnName: 'id',
                    value: productCategory.id,
                  ),
                  DataGridCell<String>(
                    columnName: 'name',
                    value: productCategory.name,
                  ),
                  DataGridCell<Widget>(
                    columnName: 'actions',
                    value: _buildActionButtons(productCategory),
                  ),
                ],
              ),
            )
            .toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _productCategories;

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
