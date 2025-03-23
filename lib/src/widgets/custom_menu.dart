import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../utils/constants.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomMenu extends StatefulWidget {
  final Function(String) onMenuSelected;
  final String? selectedMenu;

  const CustomMenu({
    super.key,
    required this.onMenuSelected,
    this.selectedMenu,
  });

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  final SideMenuController _sideMenuController = SideMenuController();
  final Map<String, bool> _expandedMenus = {};

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      controller: _sideMenuController,
      style: SideMenuStyle(
        backgroundColor: ViColors.mainDefault,
        openSideMenuWidth: 250.0,
        itemBorderRadius: BorderRadius.circular(20),
        hoverColor: ViColors.hoverMenu,
        selectedHoverColor: ViColors.hoverMenu,
        selectedColor: ViColors.mainDefault,
        unselectedIconColor: ViColors.mainDefault,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(15),
        //     bottomLeft: Radius.circular(15),
        //   ),
        // ),
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
      _buildMenuItem('Dashboard', HugeIcons.strokeRoundedDashboardSquare03),
      ..._buildExpandableMenu('Transaksi', HugeIcons.strokeRoundedCalculate, [
        _buildMenuItem('Penjualan', HugeIcons.strokeRoundedCashier02),
        _buildMenuItem('Retur Penjualan', HugeIcons.strokeRoundedFolderSync),
        _buildMenuItem('Pembelian', HugeIcons.strokeRoundedCalendarAdd02),
        // _buildMenuItem('Penerimaan', HugeIcons.strokeRoundedCalendarCheckIn01),
        _buildMenuItem(
          'Retur Pembelian',
          HugeIcons.strokeRoundedCalendarCheckOut01,
        ),
      ]),
      ..._buildExpandableMenu('Laporan', HugeIcons.strokeRoundedAssignments, [
        _buildSubMenu('Laporan Penjualan'),
        _buildSubMenu('Belanja & Pengeluaran'),
        _buildSubMenu('Laba Rugi'),
      ]),
      ..._buildExpandableMenu('Master', HugeIcons.strokeRoundedArchive02, [
        _buildSubMenu('Satuan'),
        _buildSubMenu('Konversi Satuan'),
        _buildSubMenu('Kategori Produk'),
        _buildSubMenu('Kategori Member'),
        _buildSubMenu('Kategori Supplier'),
        _buildSubMenu('Produk'),
        _buildSubMenu('Supplier Produk'),
      ]),
      _buildMenuItem('Member', HugeIcons.strokeRoundedContactBook),
      _buildMenuItem('Supplier', HugeIcons.strokeRoundedAudit01),
      _buildMenuItem('Profile', HugeIcons.strokeRoundedComputerVideoCall),
      SideMenuItem(
        title: 'Logout',
        iconWidget: const Icon(HugeIcons.strokeRoundedAccess),
        onTap: (_, __) {
          widget.onMenuSelected('Logout'); // Kirim 'Logout' ke HomeScreen
        },
      ),
    ];
  }

  SideMenuItem _buildMenuItem(String title, IconData icon) {
    return SideMenuItem(
      title: title,
      iconWidget: Icon(icon, size: 24), // Pakai HugeIcons
      onTap: (_, __) {
        widget.onMenuSelected(title);
      },
    );
  }

  List<SideMenuItem> _buildExpandableMenu(
    String title,
    IconData icon,
    List<SideMenuItem> subMenus,
  ) {
    bool isExpanded = _expandedMenus[title] ?? false;

    return [
      SideMenuItem(
        title: title,
        iconWidget: Icon(icon, size: 24), // Pakai HugeIcons
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
