import 'package:flutter/material.dart';

void main() {
  runApp(LibraryApp());
}


class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management System',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> books = [];
  final TextEditingController bookNameController = TextEditingController();
  String selectedGenre = 'Drama';

  void addBook() {
    String bookName = bookNameController.text.trim();
    if (bookName.isEmpty || books.any((book) => book['name'] == bookName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book name is required or already exists.')),
      );
      return;
    }
    setState(() {
      books.add({'name': bookName, 'genre': selectedGenre});
    });
    bookNameController.clear();
  }

  void deleteBook(String bookName) {
    setState(() {
      books.removeWhere((book) => book['name'] == bookName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF87CEEB),
        title: Text('Library Management System'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Banner
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Add Book Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: bookNameController,
                    decoration: InputDecoration(
                      labelText: 'Book Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedGenre,
                          decoration: InputDecoration(
                            labelText: 'Genre',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            'Drama',
                            'Fantasy',
                            'Horror',
                            'Science',
                            'Crime',
                            'Romance',
                            'Adventure'
                          ].map((genre) => DropdownMenuItem(
                                value: genre,
                                child: Text(genre),
                              )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGenre = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, 
                    child: ElevatedButton(
                      onPressed: addBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87CEEB),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Add Book'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Number of books: ${books.length}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Books List
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: books.isEmpty
                  ? Center(
                      child: Text(
                        'No books added yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            title: Text(book['name']!),
                            subtitle: Text('Genre: ${book['genre']}'),
                            trailing: Icon(Icons.delete, color: Colors.red),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(book: book),
                                ),
                              );
                            },
                            onLongPress: () {
                              deleteBook(book['name']!);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
class DetailsPage extends StatelessWidget {
  final Map<String, String> book;

  DetailsPage({required this.book});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF87CEEB),
      body: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Book Banner Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/book.jpg',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context,error,StackTrace){
                      return Text('LOADING');
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Book Name
                Text(
                  book['name']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                // Book Genre
                Text(
                  'Genre: ${book['genre']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),

                // Close Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF87CEEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
