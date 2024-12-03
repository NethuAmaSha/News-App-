import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../widgets/news_tile.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Articles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Articles',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchArticles(context);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewsViewModel>(
              builder: (context, newsViewModel, child) {
                if (newsViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: newsViewModel.articles.length,
                  itemBuilder: (context, index) {
                    final article = newsViewModel.articles[index];
                    return NewsTile(
                      article: article,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchArticles(BuildContext context) {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<NewsViewModel>(context, listen: false).filterArticles(query);
    }
  }
}
