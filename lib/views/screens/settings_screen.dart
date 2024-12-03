import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../main.dart';
import '../../viewmodels/news_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCategory = 'General';
  bool _isDarkTheme = false;
  bool _enableNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategory = prefs.getString('defaultCategory') ?? 'General';
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      _enableNotifications = prefs.getBool('enableNotifications') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCategory', _selectedCategory);
    await prefs.setBool('enableNotifications', _enableNotifications);
    // Notify NewsViewModel to load the default category
    Provider.of<NewsViewModel>(context, listen: false).setDefaultCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Default Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Constants.categories.length,
              itemBuilder: (context, index) {
                final category = Constants.categories[index];
                return ListTile(
                  title: Text(category),
                  trailing: _selectedCategory == category
                      ? Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _savePreferences();
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light/Dark Mode', style: TextStyle(fontSize: 18)),
                Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                    setState(() {
                      _isDarkTheme = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Notifications', style: TextStyle(fontSize: 18)),
                Switch(
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                    _savePreferences();
                    // Show a snackbar message to indicate the change
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_enableNotifications
                            ? 'Notifications Enabled'
                            : 'Notifications Disabled'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
