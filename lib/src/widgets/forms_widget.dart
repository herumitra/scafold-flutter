import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FormWidgets {

  // Reusable TextField => buildTextField
  static Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 450,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.mainDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.greyColor),
          ),
          labelStyle: const TextStyle(color: ViColors.textDefault),
          hintStyle: const TextStyle(color: ViColors.textDefault),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          alignLabelWithHint: true, // Biar label sejajar dengan teks area
        ),
        validator:
            (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  // Reusable TextAreaField => buildTextAreaField 
  static Widget buildTextAreaField(
      String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 450, // Atur lebar minimum
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.mainDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.greyColor),
          ),
          labelStyle: const TextStyle(color: ViColors.textDefault),
          hintStyle: const TextStyle(color: ViColors.textDefault),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          alignLabelWithHint: true, // Biar label sejajar dengan teks area
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null, // Supaya bisa lebih dari satu baris
        minLines: 4, // Tinggi awal 3 baris
        validator:
            (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  // Reusable CustomDropdown => buildDropdown
  static Widget buildCustomDropdown({
    required int? selectedValue,
    required List<Map<String, dynamic>> options,
    required ValueChanged<int?> onChanged,
    String CustomLabelText = "Options",
    String validatorMessage = "Wajib pilih option", // Tambahkan parameter untuk pesan validasi
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 450,
      child: DropdownButtonFormField<int>(
        padding: const EdgeInsets.all(3),
        value: selectedValue,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<int>>((option) {
          return DropdownMenuItem<int>(
            value: option["id"],
            child: Text(option["name"]),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: CustomLabelText,
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.mainDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ViColors.greyColor),
          ),
          labelStyle: const TextStyle(color: ViColors.textDefault),
          hintStyle: const TextStyle(color: ViColors.textDefault),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          alignLabelWithHint: true, // Biar label sejajar dengan teks area
        ),
        validator: (value) => value == null ? validatorMessage : null,
      ),
    );
  }
}

class AppWidgets{
  // Reusable AppBar => buildAppBar
  static PreferredSizeWidget buildAppBar(String titleBar) {
    return AppBar(
      title: Text(
        titleBar,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ViColors.mainDefault,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  // Reusable SearchBar => buildSearchBar
  static Widget buildSearchBar({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String hintText = "Cari...",
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(color: ViColors.textDefault),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: ViColors.textDefault),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 65, 66, 68)),
          labelText: hintText,
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 65, 66, 68),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ViColors.mainDefault),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // Reusable AppHeader => buildAppHeader
  static Widget buildAppHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      color: ViColors.mainDefault,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}