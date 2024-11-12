import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // Add this import to use ImageFilter

import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadbtech/searchscreen.dart';  // Make sure SearchScreen is properly defined

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),  // Define SearchScreen route
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  int _selectedIndex = 0; // Track selected bottom navigation index

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  // Handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 5 : (screenWidth > 400 ? 3 : 2); // Adjust grid columns based on screen width





    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Playflix',
          style: TextStyle(
      color:  Color.fromARGB(255, 212, 69, 3),  // Set the color of the title text
      fontSize: 24.0,        // Set the font size of the title text
      fontWeight: FontWeight.bold,  // Make the title bold
      letterSpacing: 2.0,    // Optional: Add some spacing between letters
    ),),
        actions: [
         if (_selectedIndex != 1)
          // Search Icon button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to the SearchScreen when search icon is pressed
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),

      body: _selectedIndex == 0
          ? movies.isEmpty
              ?const  Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add Title at the top of the screen
                       const  Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Text(
                            'MOVIES', // Title text
                            style: TextStyle(
                              fontSize: 26.0,
                          
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child:  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,  // Dynamically adjust based on screen width
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        var movie = movies[index]['show'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: movie,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:MovieTile(movie: movie)
                          ),
                        );
                      },
                          )
                        )
                      ]
                    );
                  },
                )
          : SearchScreen(), // Show SearchScreen when index is 1
      backgroundColor: Colors.black,

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items:const [
                  BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
class MovieTile extends StatefulWidget {
  final Map movie;

  const MovieTile({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CachedNetworkImage(
              imageUrl: widget.movie['image']?['medium'] ??
                  'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) =>const CircularProgressIndicator(),
               errorWidget: (context, url, error) => const Center(
                child: Text(
                  'Failed to load image',
                  style: TextStyle(color:  Color.fromARGB(255, 247, 245, 245)),
                ),
              ),
            ),
          ),
          // Background blur when hover
          if (_isHovered)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          // Short movie details when hover
          if (_isHovered)
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie['name'] ?? 'No Title',
                    style:const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                 const  SizedBox(height: 8.0),
                  Text(
                    widget.movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Summary Available',
                    style: const TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

