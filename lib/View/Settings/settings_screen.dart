import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Controller/ServicesProvider.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Profile/Controller/ProfilePageController.dart';
import 'package:unity_test/View/Profile/ProfilePage.dart';

class SettingsScreen extends StatelessWidget {
  final String userType;

  const SettingsScreen({required this.userType, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                ServicesProvider.logout(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('Edit language'),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            const Divider(),
            if (userType == 'student' ||
                userType == 'teacher' ||
                userType == 'employee')
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Modify personal data'),
                onTap: () {
                  CustomRoute.RouteTo(
                      context,
                      ChangeNotifierProvider(
                        create: (context) =>
                            ProfilePageController()..GetProfile(context),
                        builder: (context, child) => ProfilePage(),
                      ));
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.green),
              title: const Text('About the app'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change language'),
          content: const Text('Choose your preferred language:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('The language has been changed to Arabic')),
                );
              },
              child: const Text('Arabic'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language changed to English')),
                );
              },
              child: const Text('English'),
            ),
          ],
        );
      },
    );
  }
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'University Navigation Application',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This application helps students and staff of the university to navigate easily within the campus,'
              'In addition to providing many useful services such as map display, notifications, and student program.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Copyright © 2025',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPersonalDataPage extends StatefulWidget {
  final String userType;

  const EditPersonalDataPage({required this.userType, super.key});

  @override
  State<EditPersonalDataPage> createState() => _EditPersonalDataPageState();
}

class _EditPersonalDataPageState extends State<EditPersonalDataPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تعبئة الحقول بالبيانات الحالية (للتجربة فقط)
    if (widget.userType == 'student') {
      _nameController.text = 'Student name';
      _emailController.text = 'student@example.com';
      _phoneController.text = '1234567890';
    } else if (widget.userType == 'teacher') {
      _nameController.text = 'Professor name';
      _emailController.text = 'teacher@example.com';
      _phoneController.text = '0987654321';
    } else if (widget.userType == 'employee') {
      _nameController.text = 'Employee Name';
      _emailController.text = 'employee@example.com';
      _phoneController.text = '0987654321';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify personal data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'The name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // منطق حفظ البيانات المعدلة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved successfully.!')),
                );
              },
              child: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
