import 'package:flutter/material.dart';
import 'package:main_project/favoritepage.dart';
import 'package:main_project/historypage.dart';
import 'package:main_project/profilepage.dart';



void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Ensures latest Material design support
      ),
      home: DictionarySearchPage(),
    );
  }
}

class DictionarySearchPage extends StatefulWidget {
  @override
  _DictionarySearchPageState createState() => _DictionarySearchPageState();
}

class _DictionarySearchPageState extends State<DictionarySearchPage> {
  int _selectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pages = [
    DictionarySearchContent(),
    FavoritesPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  // Change the page when a navigation item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 165, 227),
        title: Text('Dictionary',
            style: TextStyle(fontFamily: 'WendyOne', fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 5,
      ),
      body: _pages[_selectedIndex],  // Display the page based on selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 28),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 28),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,  // Set the index of the currently selected item
        selectedItemColor: Color.fromARGB(255, 94, 165, 227), // Active color for selected item
        unselectedItemColor: Colors.black54, // Inactive color for unselected items
        backgroundColor: Colors.white,  // Background color of the bottom navigation
        elevation: 10,
        iconSize: 26, // Default icon size
        selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: 'Inder', fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Inder'),
        type: BottomNavigationBarType.fixed, // Ensures labels are always visible
        onTap: _onItemTapped,  // Handle tab change
      ),
    );
  }
}

class DictionarySearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2),
              ],
            ),
            child: TextField(
              style: TextStyle(fontFamily: 'inder'),
              decoration: InputDecoration(
                hintText: 'Search for words here...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 94, 165, 227),
                ),
                suffixIcon: Icon(
                  Icons.mic,
                  color: Color.fromARGB(255, 94, 165, 227),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Results will be displayed here',
              style: TextStyle(fontFamily: 'Inder', fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
