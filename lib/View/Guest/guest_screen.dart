import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  int _selectedIndex = 0;

  final List<Widget> _guestScreens = [
    const GuestMapScreen(),
    const GuestHomeScreen(),
    const GuestSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _guestScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

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
              page: const UniversityNewsScreen(),
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

// صفحات جديدة لعرض المحتوى داخلها
class UniversityNewsScreen extends StatelessWidget {
  const UniversityNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University News')),
      body: const Center(
          child: Text(
              'Here you can view the latest news and topics related to the university..')),
    );
  }
}

class AdmissionScreen extends StatelessWidget {
  const AdmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admission and Registration')),
      body:
          const Center(child: Text('Admission and registration details here.')),
    );
  }
}

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Manual')),
      body: const Center(child: Text('User manual details here.')),
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
              Navigator.pushNamed(context, '/login');
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
