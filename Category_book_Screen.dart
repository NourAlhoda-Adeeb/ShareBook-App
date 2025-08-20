import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryBooksScreen extends StatelessWidget {
  final String category;

  const CategoryBooksScreen({super.key, required this.category});

  //  إنشاء دالة لفتح رابط الـ PDF
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Books'),
        backgroundColor: Colors.black,
      ),
      // عرض كتب من فايربيز
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No books found in this category.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final title = book['title'] ?? 'No Title';
              final imageUrl = book['imageUrl'] ?? '';
              final author = book['author'] ?? 'Unknown Author';
              final description = book['description'] ?? 'No description';
              final bookCategory = book['category'] ?? 'Unknown Category';
              //  جلب رابط الـ PDF من Firebase
              final pdfUrl = book['pdfURL'] as String?; // استخدم as String? لضمان النوع


              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.startsWith('http' )
                        ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      imageUrl,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    author,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        // تفاصيل الكتاب
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // مهم لجعل الحجم مناسباً للمحتوى
                              children: [
                                Text(title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("Author: $author"),
                                const SizedBox(height: 8),
                                Text("Category: $bookCategory"),
                                const SizedBox(height: 12),
                                if (imageUrl.isNotEmpty)
                                  Center(
                                    child: Image.network(
                                      imageUrl,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Text(description,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 16),

                                //  إضافة الزر الخاص بملف الـ PDF
                                // سيظهر الزر فقط إذا كان رابط الـ PDF موجوداً
                                if (pdfUrl != null && pdfUrl.isNotEmpty)
                                  Center(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.picture_as_pdf),
                                      label: const Text('Book PDF'),
                                      onPressed: () {
                                        _launchURL(pdfUrl);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
