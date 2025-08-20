import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_first_project/Categories_Screen.dart';
import 'package:flutter_first_project/ReadBook_Screen.dart';
import 'package:flutter_first_project/Account_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // رقم الشاشة
  int selectedFilterIndex = 0;
  final List<String> filters = ['This Week', 'This Month', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildMainHome(),
          const CategoriesScreen(),
          const ReadBooksScreen(),
          const AccountScreen(),
        ],
      ),
      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildMainHome() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSectionHeader('Top Books'),
          _buildFilterButtons(),
          const SizedBox(height: 24),
          _buildBooksFromFirestore(filterTop: true),
          const SizedBox(height: 24),
          _buildSectionHeader('Latest Books'),
          _buildBooksFromFirestore(filterTop: false),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Happy Reading!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
// يبان العنوان Top books
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          const Text(
            'SEE MORE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(filters.length, (index) {
          final isSelected = selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.black : Colors.transparent,
                side: const BorderSide(color: Colors.black),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
// لسحب الكتب
  Widget _buildBooksFromFirestore({bool filterTop = false}) {
    Query booksQuery = FirebaseFirestore.instance.collection('books');

    if (filterTop) {
      booksQuery = booksQuery.where('isTop', isEqualTo: true);
    } else {
      booksQuery = booksQuery.orderBy('uploadedAt', descending: true);
    }

    // يعرض الكتب
    return StreamBuilder<QuerySnapshot>(
      stream: booksQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No books found"));
        }

        final books = snapshot.data!.docs;

        return SizedBox(
          height: 280,
          // لعرض الكتب افقي فيها صورة وعنوان
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final title = book['title'] ?? '';
              final imageUrl = book['imageUrl'] ?? '';

              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 120,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}