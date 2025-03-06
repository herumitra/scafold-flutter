import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../utils/constants.dart';

class CustomMenu extends StatefulWidget {
  final Function(String) onMenuSelected;
  final String? selectedMenu;

  const CustomMenu({Key? key, required this.onMenuSelected, this.selectedMenu})
    : super(key: key);

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  final SideMenuController _sideMenuController = SideMenuController();
  Map<String, bool> _expandedMenus = {};

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      controller: _sideMenuController,
      style: SideMenuStyle(
        backgroundColor: ViColors.mainDefault,
        hoverColor: ViColors.hoverMenu,
        selectedHoverColor: ViColors.hoverMenu,
        selectedColor: ViColors.mainDefault,
        unselectedIconColor: ViColors.mainDefault,
        selectedTitleTextStyle: ViDefaultFont.copyWith(
          fontSize: ViSize.defaultFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        unselectedTitleTextStyle: ViDefaultFont.copyWith(
          fontSize: ViSize.defaultFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7.5, right: 7.5),
            child: ClipRRect(
              child: Image.asset(
                'assets/images/ziida.png',
                width: 70,
                height: 70,
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
      items: _buildMenuItems(),
    );
  }

  List<SideMenuItem> _buildMenuItems() {
    return [
      _buildMenuItem('Dashboard', 'assets/icons/dashboard.png'),
      ..._buildExpandableMenu('Transaksi', 'assets/icons/transaksi.png', [
        _buildSubMenu('Pembelian'),
        _buildSubMenu('Penjualan'),
        _buildSubMenu('Penerimaan'),
        _buildSubMenu('Retur Pembelian'),
        _buildSubMenu('Retur Penjualan'),
      ]),
      ..._buildExpandableMenu('Laporan', 'assets/icons/laporan.png', [
        _buildSubMenu('Laporan Penjualan'),
        _buildSubMenu('Belanja & Pengeluaran'),
        _buildSubMenu('Laba Rugi'),
      ]),
      ..._buildExpandableMenu('Master', 'assets/icons/master.png', [
        _buildSubMenu('Satuan'),
        _buildSubMenu('Konversi Satuan'),
        _buildSubMenu('Kategori Produk'),
        _buildSubMenu('Kategori Member'),
        _buildSubMenu('Kategori Supplier'),
        _buildSubMenu('Produk'),
        _buildSubMenu('Member'),
        _buildSubMenu('Supplier'),
        _buildSubMenu('Supplier Produk'),
      ]),
      _buildMenuItem('Profile', 'assets/icons/profile.png'),
      SideMenuItem(
        title: 'Logout',
        iconWidget: const Icon(Icons.logout, color: Colors.red),
        onTap: (_, __) {
          // Tambahkan logika logout di sini
        },
      ),
    ];
  }

  SideMenuItem _buildMenuItem(String title, String assetPath) {
    return SideMenuItem(
      title: title,
      iconWidget: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ),
      onTap: (_, __) {
        widget.onMenuSelected(title);
      },
    );
  }

  List<SideMenuItem> _buildExpandableMenu(
    String title,
    String assetPath,
    List<SideMenuItem> subMenus,
  ) {
    bool isExpanded = _expandedMenus[title] ?? false;

    return [
      SideMenuItem(
        title: title,
        iconWidget: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
        onTap: (_, __) {
          setState(() {
            _expandedMenus.updateAll((key, value) => false);
            _expandedMenus[title] = !isExpanded;
          });
        },
        trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
      ),
      if (isExpanded) ...subMenus,
    ];
  }

  SideMenuItem _buildSubMenu(String title) {
    return SideMenuItem(
      title: title,
      iconWidget: const Icon(Icons.arrow_right),
      onTap: (_, __) {
        widget.onMenuSelected(title);
      },
    );
  }
}
