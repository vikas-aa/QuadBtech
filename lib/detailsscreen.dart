import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments == null) {
      return Scaffold(
        body: Center(
          child: Text('No data available'),
        ),
      );
    }
    final movie = arguments;

    final imageUrl = movie['image']?['original'] ?? 'https://via.placeholder.com/500x750';
    final movieName = movie['name'] ?? 'No Title';
    final movieSummary = movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Summary Available';

    return Scaffold(
      backgroundColor: Colors.black, // Set background to black, like Netflix
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar to let image show
        elevation: 0, // Remove the shadow for a cleaner look
        title: Text(
          movieName,
          style: const TextStyle(color: Colors.white), // White text on AppBar
        ),
      ),
      body: Column(
        children: [
          // Stack to position the button on top of the image
          Stack(
            children: [
              // Background Image (fixed height, non-scrollable)
              Container(
                height: 300, // Fixed height for the image
                width: double.infinity, // Take the full width
                child: Image.network(
                  imageUrl,
                  height: 500, // Ensure the image covers the space
                  width: 500, // Ensure the image covers the entire container
                  loadingBuilder: (context, child, progress) {
                    // If loading, show a progress indicator
                    if (progress == null) {
                      return child; // If loaded, return the image
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // If error loading the image, show a text message
                    return const Center(
                      child: Text(
                        'Failed to load Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Play button positioned at the left corner of the image
              Positioned(
                left: 17.0, // Position it 16 pixels from the left
                bottom: 8.0, // Position it 16 pixels from the bottom
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to video player or take other action
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text('Play', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.3, // 30% of the screen width
                      50, // Increased height
                    ),
                    backgroundColor: Colors.white, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  ),
                ),
              ),
            ],
          ),
          // Gradient overlay to improve text readability
          Container(
            color: Colors.black.withOpacity(0.6), // Semi-transparent black overlay
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title
                  Text(
                    movieName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Movie summary
                  Text(
                    movieSummary,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Light gray text for summary
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
