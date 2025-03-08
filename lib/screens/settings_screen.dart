import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _cloudSync = false;
  String _currency = 'USD';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: 'Appearance'),
          _SettingsSwitch(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setDarkMode(value);
            },
          ),
          const Divider(),

          const _SettingsHeader(title: 'Notifications'),
          _SettingsSwitch(
            title: 'Enable Notifications',
            subtitle: 'Get alerts for budget limits and reminders',
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
          const Divider(),

          const _SettingsHeader(title: 'Data & Sync'),
          _SettingsSwitch(
            title: 'Cloud Sync',
            subtitle: 'Sync your data across devices',
            value: _cloudSync,
            onChanged: (value) {
              setState(() {
                _cloudSync = value;
              });
            },
          ),
          ListTile(
            title: const Text('Currency'),
            subtitle: Text(_currency),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showCurrencyPicker();
            },
          ),
          const Divider(),

          const _SettingsHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to security screen
            },
          ),
          const Divider(),

          const _SettingsHeader(title: 'About'),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {
              // Show terms of service
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // Show privacy policy
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement logout functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Log Out'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('USD - US Dollar'),
                onTap: () {
                  setState(() {
                    _currency = 'USD';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('EUR - Euro'),
                onTap: () {
                  setState(() {
                    _currency = 'EUR';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('GBP - British Pound'),
                onTap: () {
                  setState(() {
                    _currency = 'GBP';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('JPY - Japanese Yen'),
                onTap: () {
                  setState(() {
                    _currency = 'JPY';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('NPR - Nepalese Rupee'),
                onTap: () {
                  setState(() {
                    _currency = 'NPR';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }
}
