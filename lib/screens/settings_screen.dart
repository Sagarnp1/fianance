import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/providers/auth_provider.dart';
import 'package:financetracker/providers/transaction_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Account Section
              _buildSection(
                context,
                title: 'Account',
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Account Info'),
                        subtitle:
                            Text(authProvider.user?.email ?? 'Not signed in'),
                      );
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.cloud_sync),
                    title: const Text('Cloud Sync'),
                    subtitle: const Text('Sync your data across devices'),
                    value: transactionProvider.isCloudSyncEnabled,
                    onChanged: (value) {
                      transactionProvider.setCloudSyncEnabled(value);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Appearance Section
              _buildSection(
                context,
                title: 'Appearance',
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Coming soon'),
                    enabled: false,
                  ),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Theme Color'),
                    subtitle: const Text('Coming soon'),
                    enabled: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Data Section
              _buildSection(
                context,
                title: 'Data',
                children: [
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Export Data'),
                    subtitle: const Text('Export your transactions as CSV'),
                    onTap: () {
                      // TODO: Implement export functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Export feature coming soon')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.upload),
                    title: const Text('Import Data'),
                    subtitle: const Text('Import transactions from CSV'),
                    onTap: () {
                      // TODO: Implement import functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Import feature coming soon')),
                      );
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Clear All Data',
                        style: TextStyle(color: Colors.red)),
                    subtitle: const Text('This action cannot be undone'),
                    onTap: () {
                      _showClearDataDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // About Section
              _buildSection(
                context,
                title: 'About',
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Rate App'),
                    onTap: () {
                      // TODO: Open app store rating
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Rating feature coming soon')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      // TODO: Open privacy policy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Privacy policy coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'Are you sure you want to clear all your data? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // TODO: Implement clear data functionality
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Clear data feature coming soon')),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
