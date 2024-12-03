import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/news_article.dart';
import '../../viewmodels/news_viewmodel.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBookmarked = Provider.of<NewsViewModel>(context).isBookmarked(article);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // Gradient background in light mode
        backgroundColor: isDarkMode ? Colors.black87 : Colors.transparent,
        flexibleSpace: isDarkMode
            ? null
            : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple], // Gradient colors
            ),
          ),
        ),
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.white, // Ensure text is visible
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<NewsViewModel>(context, listen: false).toggleBookmark(article);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section: Increased size and border radius
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300, // Increased image size for prominence
                ),
              ),
            SizedBox(height: 16.0),

            // Title Section: Larger font for better visibility
            Text(
              article.title,
              style: TextStyle(
                fontSize: 28,  // Larger title size
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),

            // Date Published Section
            Text(
              "Published At: ${article.publishedAt}",
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),

            // Description Section: Increased font size
            Text(
              article.description,
              style: TextStyle(
                fontSize: 18,  // Larger font for description
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 20.0),

            // Content Section: Improved readability with larger font size
            Text(
              article.content ?? "No further content available.",
              style: TextStyle(
                fontSize: 18,  // Larger font size for content
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: isDarkMode ? Colors.black87 : Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Share button
              IconButton(
                icon: Icon(Icons.share, color: isDarkMode ? Colors.white : Colors.blueAccent),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share action pressed.')),
                  );
                },
              ),

              // 'Read Full Article' button
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(article.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not launch the article. Please try again later.'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Read Full Article',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black, // Font color change for visibility
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blueAccent : Colors.blue,
                ),
              ),

              // Bookmark button
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isDarkMode ? Colors.white : Colors.blueAccent,
                ),
                onPressed: () {
                  Provider.of<NewsViewModel>(context, listen: false).toggleBookmark(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
