import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

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
        setState(() {
          profileData = jsonDecode(profileJson);
        });
      } catch (e) {
        print("Error saat decoding JSON: $e");
      }
    } else {
      await _fetchProfileFromAPI();
    }
  }

  Future<void> _fetchProfileFromAPI() async {
    await ApiService().fetchProfile();
    _loadProfileData(); // Muat ulang data setelah API selesai
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

                  // Nama dan Email di bagian atas
                  Text(
                    profileData!['name'] ?? "-",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profileData!['email'] ?? "-",
                    style: TextStyle(fontSize: 16, color: ViColors.textDefault),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // Informasi lainnya dalam ListView
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProfileRow(
                          Icons.phone,
                          "No HP",
                          profileData!['phone'],
                        ),
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
          Icon(icon, color: ViColors.textDefault, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value ?? "-",
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
