import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BranchesScreen extends StatelessWidget {
  final List<dynamic> branches;

  const BranchesScreen({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Cabang / Outlet',style: TextStyle(fontWeight: FontWeight.bold, color: ViColors.whiteColor)),
        backgroundColor: ViColors.mainDefault,
        centerTitle: true,
        automaticallyImplyLeading: false
      ),
      body: ListView.builder(
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
          return Card(
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text(branch['branch_name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SIA: ${branch['sia_name']}'),
                  Text('SIPA: ${branch['sipa_name']}'),
                  Text('Telepon: ${branch['phone']}'),
                ],
              ),
              leading: Icon(Icons.business, color: ViColors.mainDefault),
            ),
          );
        },
      ),
    );
  }
}
