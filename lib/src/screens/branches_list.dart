import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import '../utils/constants.dart'; // Import ViColors
import 'home_screen.dart'; // Import HomeScreen

class BranchesScreen extends StatelessWidget {
  final List<dynamic> branches;

  const BranchesScreen({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Daftar Cabang / Outlet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ViColors.whiteColor,
            ),
          ),
          backgroundColor: ViColors.mainDefault,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: HoverableBranchItem(branch: branch),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HoverableBranchItem extends StatefulWidget {
  final Map<String, dynamic> branch;

  const HoverableBranchItem({super.key, required this.branch});

  @override
  _HoverableBranchItemState createState() => _HoverableBranchItemState();
}

class _HoverableBranchItemState extends State<HoverableBranchItem> {
  bool _isHovered = false;

  Future<void> _setBranch(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenJWT');

      if (token == null || token.isEmpty) {
        _showErrorDialog(context, 'Token tidak ditemukan. Harap login ulang.');
        return;
      }

      bool confirm = await _showConfirmationDialog(context);
      if (!confirm) return;

      final dio = Dio();
      final response = await dio.post(
        'http://api.vimedika.com:4001/set_branch',
        data: {"branch_id": widget.branch['branch_id']},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      // debugPrint("Response set_branch: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final newToken = response.data['data'];

        await prefs.setString('tokenJWT', newToken);
        await _fetchProfile(context, newToken);
      } else {
        _showErrorDialog(
          context,
          response.data['message'] ?? 'Gagal memilih cabang.',
        );
      }
    } catch (e) {
      // debugPrint("Error set_branch: $e");
      _showErrorDialog(context, 'Terjadi kesalahan, coba lagi.');
    }
  }

  Future<void> _fetchProfile(BuildContext context, String newToken) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://api.vimedika.com:4001/profile',
        options: Options(
          headers: {"Authorization": "Bearer $newToken"},
          validateStatus: (status) => status! < 500,
        ),
      );

      // debugPrint("Response profile: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final profileData = response.data['data'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileData', profileData.toString());

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500),
            child: const HomeScreen(),
          ),
        );
      } else {
        _showErrorDialog(context, 'Gagal mengambil data profil.');
      }
    } catch (e) {
      // debugPrint("Error profile: $e");

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profileData');

      _showErrorDialog(context, 'Token tidak valid, harap login ulang.');
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi'),
              content: Text(
                'Cabang / Outlet sudah terpilih dengan nama outlet ${widget.branch['branch_name']}. '
                'Klik OK jika sudah sesuai, atau Cancel jika ingin mengganti.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('OK'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => _setBranch(context),
            child: ClayContainer(
              borderRadius: 25,
              depth: 50,
              spread: 1,
              color: _isHovered ? ViColors.mainDefault : Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Icon(
                  Icons.business,
                  color: _isHovered ? Colors.white : ViColors.mainDefault,
                  size: 35,
                ),
                title: Text(
                  widget.branch['branch_name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _isHovered ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'SIA: ${widget.branch['sia_name']}',
                      style: TextStyle(
                        color: _isHovered ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'SIPA: ${widget.branch['sipa_name']}',
                      style: TextStyle(
                        color: _isHovered ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Telepon: ${widget.branch['phone']}',
                      style: TextStyle(
                        color: _isHovered ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
