import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'auth_screen.dart';
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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMenu = 'Dashboard';

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenJWT');
    final profile = prefs.getString('profileData');

    if (token == null || profile == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const AuthScreen(),
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data di SharedPreferences

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const AuthScreen(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> _confirmLogout() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah kamu yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _logout();
    } else {
      setState(() {
        _selectedMenu = 'Dashboard'; // Balik ke Dashboard kalau batal
      });
    }
  });
}


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
      case 'Logout': 
        _confirmLogout(); // Panggil dialog konfirmasi logout
        return DashboardItem(); // Tetap tampilkan dashboard sementara
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
              padding: const EdgeInsets.all(16.0),
              child: _getSelectedPage(_selectedMenu),
            ),
          ),
        ],
      ),
    );
  }
}
