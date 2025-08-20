import 'package:flutter/material.dart';
import 'package:flutter_first_project/Category_book_Screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Home
      Navigator.pop(context);
    } else if (index == 2) {
    } else if (index == 3) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              //  شبكة التصنيفات
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildCategoryTile('Classics', 'images/ClaBook2.jpg', context),
                    _buildCategoryTile('Science fiction', 'images/ClaBook3.jpg', context),
                    _buildCategoryTile('Romantic', 'images/ClaBook4.jpg', context),
                    _buildCategoryTile('Horror', 'images/ClaBook1.jpg', context),
                    _buildCategoryTile('Historical', 'images/ClaBook5.jpg', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // نصمم كل تصنيف
  Widget _buildCategoryTile(String title, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryBooksScreen(category: title), // يمشي لشاشة تصنيف الكتاب
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}