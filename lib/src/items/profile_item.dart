import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

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

    // print("Data dari SharedPreferences: $profileJson"); // Debugging

    if (profileJson != null) {
      try {
        setState(() {
          profileData = jsonDecode(profileJson);
        });
      } catch (e) {
        // print("Error saat decoding JSON: $e");
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileRow("Nama", profileData!['name']),
                  _buildProfileRow("Email", profileData!['email']),
                  _buildProfileRow("No HP", profileData!['phone']),
                  _buildProfileRow("Cabang", profileData!['branch_name']),
                  _buildProfileRow("Alamat", profileData!['address']),
                  _buildProfileRow("SIA", profileData!['sia_name']),
                  _buildProfileRow("PSA", profileData!['psa_name']),
                  _buildProfileRow("SIPA", profileData!['sipa_name']),
                  _buildProfileRow(
                    "Pajak (%)",
                    "${profileData!['tax_percentage']}%",
                  ),
                  _buildProfileRow(
                    "Metode Jurnal",
                    profileData!['journal_method'],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildProfileRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? "-", overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
