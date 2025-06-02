import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_test/Services/Routes.dart';
import 'package:unity_test/View/Announcement/AnnouncementPage.dart';
import 'package:unity_test/View/Announcement/Controller/AnnouncementPageController.dart';
import 'package:unity_test/View/Auth/Login/Controller/LoginController.dart';
import 'package:unity_test/View/Auth/Login/LoginPage.dart';

class GuestMapScreen extends StatefulWidget {
  const GuestMapScreen({super.key});

  @override
  State<GuestMapScreen> createState() => _GuestMapScreenState();
}

class _GuestMapScreenState extends State<GuestMapScreen> {
  bool _is3DView = false;
  String _mapStatus = " Download map...";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _mapStatus = "The map is ready.!";
      });
    });
  }

  void _toggleMapView() {
    setState(() {
      _is3DView = !_is3DView;
      _mapStatus = _is3DView ? "3D map view" : "2D map view";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_mapStatus)),
    );
  }

  // تحديث موقع المستخدم مع نافذة تحذير
  void _updateUserLocation() {
    _showLoginRequiredDialog();
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You must log in before updating your location.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            color: Colors.white, // جعل النص أبيض
            fontWeight: FontWeight.bold, // جعل النص بولد
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn2D",
                  onPressed: _toggleMapView,
                  child: const Icon(Icons.map),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn3D",
                  onPressed: _toggleMapView,
                  child: const Icon(Icons.threed_rotation),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn3D",
                  onPressed: _updateUserLocation,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// الصفحة الرئيسية للزائر
class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white, // جعل النص أبيض
            fontWeight: FontWeight.bold, // جعل النص بولد
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 10.0, // المسافة بين الأعمدة
          mainAxisSpacing: 10.0, // المسافة بين الصفوف
          children: [
            _buildOptionCard(
              context,
              title: 'University News',
              icon: Icons.article,
              page: ChangeNotifierProvider(
                create: (context) =>
                    AnnouncementPageController()..GetAllAnnouncements(context),
                builder: (context, child) => AnnouncementPage(),
              ),
            ),
            _buildOptionCard(
              context,
              title: 'Admission and Registration',
              icon: Icons.map,
              page: const AdmissionScreen(),
            ),
            _buildOptionCard(
              context,
              title: 'User Manual',
              icon: Icons.help_outline,
              page: const UserGuideScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // وظيفة لإنشاء كل بطاقة خيار
  Widget _buildOptionCard(BuildContext context,
      {required String title, required IconData icon, required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        color: const Color(0xFFE0F7FA),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF004D40)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AdmissionScreen extends StatelessWidget {
  const AdmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admission and Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF004D40),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // إضافة صورة تعبيرية أعلى النص
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // زوايا دائرية للصورة
              child: Image.asset(
                'assets/images/admission.jpg', // تأكد من وضع الصورة داخل مجلد assets
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20), // مسافة بين الصورة والنص

            // تنسيق النص
            const Text(
              'The university\'s main center provides access to all essential services for visitors. '
              'Located in a semi-strategic position, it houses finance, student affairs, registration, and reception. '
              'Visit the campus to learn more about its facilities and benefits.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.5, // تحسين المسافات بين الأسطر
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Manual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF004D40),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'User Guide',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              SizedBox(height: 12), // مسافة بين العنوان والنص
              Text(
                'This application provides an indoor navigation system within the building. '
                'It enables users to locate specific places and view their path using augmented reality. '
                'Additionally, it allows tracking the location of specific individuals and offers various services to assist users effectively.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.6, // تحسين المسافات بين الأسطر
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Indoor navigation using augmented reality.\n'
                '• Locate and track specific people.\n'
                '• Provide detailed guidance and additional user services.\n',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحة الإعدادات (كما هي في الكود السابق)
class GuestSettingsScreen extends StatelessWidget {
  const GuestSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white, // جعل النص أبيض
            fontWeight: FontWeight.bold, // جعل النص بولد
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.login, color: Colors.teal),
            title: const Text('Login'),
            onTap: () {
              CustomRoute.RouteAndRemoveUntilTo(
                  context,
                  ChangeNotifierProvider(
                    create: (context) => LoginController(),
                    builder: (context, child) => LoginPage(),
                  ));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: const Text('Change language'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.teal),
            title: const Text('About the application'),
            onTap: () {
              _showAboutAppDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change language'),
          content: const Text('Choose your preferred language:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('The language has been changed to Arabic.')),
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

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About the application'),
          content: const Text(
            'This application was developed to provide a unique experience for users.\n Version: 1.0.0 \n Developer: Team.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Closing'),
            ),
          ],
        );
      },
    );
  }
}
