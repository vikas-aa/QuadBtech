import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // Import to use ImageFilter for blur

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  String searchQuery = '';
  Map<int, bool> _hoverStates = {}; // Map to track hover state for each item

  // Function to fetch movies based on the search query
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return; // Avoid empty queries
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            searchMovies(value);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: searchQuery.isEmpty
          ?const Center(child: Text('Explore Movies, Shows, or Genres', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))
          : searchResults.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 5 : (screenWidth > 400 ? 3 : 2), // 4 items per row on larger screens, 2 on smaller
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7, // Aspect ratio for images like Netflix thumbnails
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var movie = searchResults[index]['show'];
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _hoverStates[index] = true; // Track hover state for this item
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _hoverStates[index] = false; // Revert hover state for this item
                              });
                            },
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: movie['image']?['medium'] ?? 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) =>const  Center(child: CircularProgressIndicator()),
                                   errorWidget: (context, url, error) =>const  Center( // Show error message if image fails to load
                                        child: Text(
                                                 'Failed to load image',
                                                      style: TextStyle(
                                                  color: Colors.white,
                                                       fontSize: 14.0,
                                                     fontWeight: FontWeight.bold,
                                                       ),
                                                 ),
                                              ),
                                ),
                                // Apply blur when hovering over a specific image
                                if (_hoverStates[index] ?? false)
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.6), // Dark overlay for better visibility
                                      ),
                                    ),
                                  ),
                                // Movie details to show when hovered
                                if (_hoverStates[index] ?? false)
                                  Positioned(
                                    left: 16.0,
                                    bottom: 16.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['name'] ?? 'No Title',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
                                            ],
                                          ),
                                        ),
                                      const   SizedBox(height: 8.0),
                                        Text(
                                          movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                                              'No Summary Available',
                                          style: const TextStyle(color: Colors.white70),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
