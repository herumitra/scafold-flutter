import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AdminPage());
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final PageController _pageController = PageController();
  final SideMenuController _sideMenuController = SideMenuController();
  Map<String, bool> _expandedMenus = {}; // Untuk menyimpan state submenu

  @override
  void initState() {
    super.initState();
    _sideMenuController.addListener((index) {
      if (mounted) {
        setState(() {});
        _pageController.jumpToPage(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Menu
          SideMenu(
            controller: _sideMenuController,
            style: SideMenuStyle(
              backgroundColor: Colors.white,
              selectedColor: Colors.blue,
              hoverColor: Colors.blueAccent,
              selectedTitleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              unselectedTitleTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            title: Column(
              children: [
                // SizedBox(height: 20),
                ClipRRect(
                  //   borderRadius: BorderRadius.circular(
                  //     10,
                  //   ), // Biar sudutnya melengkung
                  child: Image.asset(
                    'assets/images/ziida.png', // Ganti dengan path logo perusahaan
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
                // SizedBox(height: 10),
                // Text(
                //   'Perusahaan XYZ', // Nama perusahaan
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                Divider(thickness: 1), // Garis pemisah sebelum menu
              ],
            ),
            items: _buildMenuItems(),
          ),

          // Halaman utama
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                10,
                (index) => Center(
                  child: Text(
                    "Halaman ${index + 1}",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Membangun daftar menu utama & submenu
  List<SideMenuItem> _buildMenuItems() {
    return [
      SideMenuItem(
        title: 'Dashboard',
        iconWidget: Icon(Icons.dashboard),
        onTap: (index, _) => _sideMenuController.changePage(index),
      ),
      ..._buildExpandableMenu("Transaksi", Icons.attach_money, [
        _buildSubMenu("Penjualan", 2),
        _buildSubMenu("Pembelian", 3),
      ]),
      ..._buildExpandableMenu("Laporan", Icons.bar_chart, [
        _buildSubMenu("Laporan Penjualan", 5),
        _buildSubMenu("Laporan Stok", 6),
      ]),
    ];
  }

  /// 🔥 Membuat Menu yang Bisa Expand/Collapse
  List<SideMenuItem> _buildExpandableMenu(
    String title,
    IconData icon,
    List<SideMenuItem> subMenus,
  ) {
    bool isExpanded = _expandedMenus[title] ?? false;

    return [
      SideMenuItem(
        title: title,
        iconWidget: Icon(icon),
        onTap: (index, _) {
          setState(() {
            _expandedMenus[title] = !isExpanded;
          });
        },
        trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
      ),
      if (isExpanded)
        ...subMenus, // ✅ FIXED! Sekarang submenu muncul dengan benar
    ];
  }

  /// 🔥 Membuat Submenu Item
  SideMenuItem _buildSubMenu(String title, int index) {
    return SideMenuItem(
      title: title,
      iconWidget: Icon(Icons.arrow_right),
      onTap: (i, _) => _sideMenuController.changePage(index),
    );
  }
}
