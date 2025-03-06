import 'package:flutter/material.dart';
import '../widgets/custom_menu.dart';
import '../items/dashboard_item.dart';
import '../items/transaksi_pembelian_item.dart';
import '../items/transaksi_penjualan_item.dart';
import '../items/transaksi_penerimaan_item.dart';
import '../items/transaksi_retur_pembelian_item.dart';
import '../items/transaksi_retur_penjualan_item.dart';
import '../items/laporan_penjualan_item.dart';
import '../items/laporan_belanja_pengeluaran_item.dart';
import '../items/laporan_laba_rugi_item.dart';
import '../items/master_satuan_item.dart';
import '../items/master_konversi_satuan_item.dart';
import '../items/master_kategori_produk_item.dart';
import '../items/master_kategori_member_item.dart';
import '../items/master_kategori_supplier_item.dart';
import '../items/master_produk_item.dart';
import '../items/master_member_item.dart';
import '../items/master_supplier_item.dart';
import '../items/master_supplier_produk_item.dart';
import '../items/profile_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMenu = 'Dashboard';

  Widget _getSelectedPage(String menuTitle) {
    switch (menuTitle) {
      case 'Dashboard':
        return DashboardItem();
      case 'Pembelian':
        return TransaksiPembelianItem();
      case 'Penjualan':
        return TransaksiPenjualanItem();
      case 'Penerimaan':
        return TransaksiPenerimaanItem();
      case 'Retur Pembelian':
        return TransaksiReturPembelianItem();
      case 'Retur Penjualan':
        return TransaksiReturPenjualanItem();
      case 'Laporan Penjualan':
        return LaporanPenjualanItem();
      case 'Belanja & Pengeluaran':
        return LaporanBelanjaPengeluaranItem();
      case 'Laba Rugi':
        return LaporanLabaRugiItem();
      case 'Satuan':
        return MasterSatuanItem();
      case 'Konversi Satuan':
        return MasterKonversiSatuanItem();
      case 'Kategori Produk':
        return MasterKategoriProdukItem();
      case 'Kategori Member':
        return MasterKategoriMemberItem();
      case 'Kategori Supplier':
        return MasterKategoriSupplierItem();
      case 'Produk':
        return MasterProdukItem();
      case 'Member':
        return MasterMemberItem();
      case 'Supplier':
        return MasterSupplierItem();
      case 'Supplier Produk':
        return MasterSupplierProdukItem();
      case 'Profile':
        return ProfileItem();
      default:
        return DashboardItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomMenu(
            onMenuSelected: (menuTitle) {
              setState(() {
                _selectedMenu = menuTitle;
              });
            },
            selectedMenu: _selectedMenu,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _getSelectedPage(_selectedMenu),
            ),
          ),
        ],
      ),
    );
  }
}
