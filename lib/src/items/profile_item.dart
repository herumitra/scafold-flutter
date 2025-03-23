import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/api_config.dart';

class ProfileItem extends StatefulWidget {
  const ProfileItem({super.key});

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('profileData');

    if (profileJson != null) {
      try {
        final decodedData = jsonDecode(profileJson);
        setState(() {
          profileData = decodedData;
        });
        return; // Kalau sudah ada data, hentikan di sini!
      } catch (e) {
        debugPrint("❌ Error saat decoding JSON: $e");
      }
    }

    // Jika tidak ada data, baru fetch dari API
    await _fetchProfileFromAPI();
  }

  Future<void> _fetchProfileFromAPI() async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenJWT');

      if (token == null) {
        debugPrint("❌ Token tidak ditemukan.");
        return;
      }

      final response = await dio.get(
        ApiConfig.profile_endpoint,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint("🔹 Response profile: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final profileData = response.data['data'];

        // Simpan ke SharedPreferences
        await prefs.setString('profileData', jsonEncode(profileData));

        setState(() {
          this.profileData = profileData;
        });

        debugPrint("✅ Profile data berhasil disimpan dan diperbarui.");
      } else {
        debugPrint("❌ Gagal mengambil profil: ${response.data['message']}");
      }
    } catch (e) {
      debugPrint("❌ Error saat mengambil profil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return profileData == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar Profil
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: ViColors.mainDefault,
                    child: Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama dan Email
                  Text(
                    profileData!['profile_name'] ?? "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profileData!['email'] ?? "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // Informasi lainnya
                  _buildProfileRow(Icons.phone, "No HP", profileData!['phone']),
                  _buildProfileRow(
                    Icons.store,
                    "Cabang",
                    profileData!['branch_name'],
                  ),
                  _buildProfileRow(
                    Icons.location_on,
                    "Alamat",
                    profileData!['address'],
                  ),
                  _buildProfileRow(
                    Icons.business,
                    "SIA",
                    profileData!['sia_name'],
                  ),
                  _buildProfileRow(
                    Icons.person,
                    "PSA",
                    profileData!['psa_name'],
                  ),
                  _buildProfileRow(
                    Icons.assignment_ind,
                    "SIPA",
                    profileData!['sipa_name'],
                  ),
                  _buildProfileRow(
                    Icons.percent,
                    "Pajak (%)",
                    "${profileData!['tax_percentage']}%",
                  ),
                  _buildProfileRow(
                    Icons.receipt,
                    "Metode Jurnal",
                    profileData!['journal_method'],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildProfileRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ViColors.mainDefault, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
