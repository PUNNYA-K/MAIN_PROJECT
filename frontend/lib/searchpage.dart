import 'package:flutter/material.dart';
import 'package:main_project/api.dart';
import 'package:main_project/favoritepage.dart';
import 'package:main_project/historypage.dart';
import 'package:main_project/profilepage.dart';
import 'package:main_project/response_model.dart';

class HomePage extends StatefulWidget {
  
    final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Welcome, Start searching";
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),  // Home Page Content
     FavoritesPage(),
     HistoryPage(),
     ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dictionary",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inder', color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 118, 182),
        elevation: 5,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 54, 118, 182),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Extracted Home Page Content
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Welcome, Start searching";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchWidget(),
          const SizedBox(height: 12),
          if (inProgress)
            const LinearProgressIndicator()
          else if (responseModel != null)
            Expanded(child: _buildResponseWidget())
          else
            _noDataWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onSubmitted: (value) {
          _getMeaningFromApi(value);
        },
        decoration: const InputDecoration(
          hintText: "Search word here",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 54, 118, 182)),
         
        ),
        style: const TextStyle(fontFamily: 'Inder'),
      ),
    );
  }

  Widget _buildResponseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          responseModel!.word!,
          style: const TextStyle(
            color: Color.fromARGB(255, 54, 118, 182),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inder',
          ),
        ),
        Text(responseModel!.phonetic ?? "", style: const TextStyle(fontFamily: 'Inder')),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildMeaningWidget(responseModel!.meanings![index]);
            },
            itemCount: responseModel!.meanings!.length,
          ),
        ),
      ],
    );
  }

  Widget _buildMeaningWidget(Meanings meanings) {
    String definitionList = "";
    meanings.definitions?.forEach((element) {
      int index = meanings.definitions!.indexOf(element);
      definitionList += "\n${index + 1}. ${element.definition}\n";
    });

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech!,
              style: const TextStyle(
                color: Color.fromARGB(255, 54, 118, 182),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Inder',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Definitions : ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Inder',
              ),
            ),
            Text(definitionList, style: const TextStyle(fontFamily: 'Inder')),
            _buildSet("Synonyms", meanings.synonyms),
            _buildSet("Antonyms", meanings.antonyms),
          ],
        ),
      ),
    );
  }

  Widget _buildSet(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Inder',
            ),
          ),
          const SizedBox(height: 10),
          Text(setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
              style: const TextStyle(fontFamily: 'Inder')),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: const TextStyle(fontSize: 20, fontFamily: 'Inder'),
        ),
      ),
    );
  }


  

  void _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
      setState(() {});
    } catch (e) {
      responseModel = null;
      noDataText = "Meaning cannot be fetched";
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
