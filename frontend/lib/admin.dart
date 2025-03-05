import 'package:flutter/material.dart';

void main() {
  runApp(AdminDashboard());
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedSection = 'Content Management';

  void _changeSection(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Content Management'),
              onTap: () => _changeSection('Content Management'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('User Management'),
              onTap: () => _changeSection('User Management'),
            ),
          ],
        ),
      ),
      body: Center(
        child: _selectedSection == 'Content Management'
            ? ContentManagementSection()
            : UserManagementSection(),
      ),
    );
  }
}

class ContentManagementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.book, size: 80, color: Colors.green),
        Text('Add Words, Meanings, Synonyms, Antonyms, Pronunciation', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

class UserManagementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people, size: 80, color: Colors.green),
        Text('View Users', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}