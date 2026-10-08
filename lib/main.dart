import 'package:flutter/material.dart';

void main() {
  runApp(const OssimApp());
}

class OssimApp extends StatefulWidget {
  const OssimApp({super.key});

  @override
  State<OssimApp> createState() => _OssimAppState();
}

class _OssimAppState extends State<OssimApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ossim',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFAFAFAF),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: LoginScreen(onThemeChanged: _toggleTheme),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const LoginScreen({super.key, required this.onThemeChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rice_bowl, size: 80, color: Colors.teal),
            const SizedBox(height: 10),
            const Text(
              'Ossim-এ স্বাগতম',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'মোবাইল নম্বর',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(onThemeChanged: widget.onThemeChanged),
                  ),
                );
              },
              child: const Text('লগইন করুন', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  String adminNotification =
      "📢 নোটিশ: আগামী ২৫ তারিখের মধ্যে চলতি মাসের মিল চার্জ পরিশোধ করুন।";

  List<Map<String, dynamic>> students = [
    {
      "id": 1,
      "name": "গালিব",
      "year": "১ম বর্ষ",
      "room": "৩০২",
      "deposit": 2000.0,
      "balance": 650.0,
    },
    {
      "id": 2,
      "name": "রাফসান",
      "year": "২য় বর্ষ",
      "room": "৩০৫",
      "deposit": 1500.0,
      "balance": -300.0,
    },
  ];

  String searchQuery = '';

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('টাকা জমা দিন (পেমেন্ট)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('পেমেন্ট মেথড নির্বাচন করুন:'),
            const SizedBox(height: 15),
            ListTile(
              leading:
                  const Icon(Icons.account_balance_wallet, color: Colors.pink),
              title: const Text('বিকাশ (bKash)'),
              onTap: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('বিকাশ গেটওয়ে রিডাইরেক্ট হচ্ছে...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.orange),
              title: const Text('নগদ (Nagad)'),
              onTap: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('নগদ গেটওয়ে রিডাইরেক্ট হচ্ছে...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = students.where((s) {
      final q = searchQuery.trim();
      if (q.isEmpty) return true;
      return s['name'].toString().contains(q) ||
          s['id'].toString().contains(q) ||
          s['room'].toString().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ossim - মিল ম্যানেজার'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                widget.onThemeChanged(isDarkMode);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      adminNotification,
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: 'স্টুডেন্ট নম্বর বা নাম দিয়ে খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final student = filtered[index];
                  final double balance = student['balance'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                child: Text('${student['id']}'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(student['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'বর্ষ: ${student['year']} | রুম: ${student['room']}'),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('জমা: ৳${student['deposit']}'),
                              Text(
                                balance >= 0
                                    ? 'পাওনা: ৳${balance.abs()}'
                                    : 'বকেয়া: ৳${balance.abs()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      balance >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _showPaymentDialog,
                            icon: const Icon(Icons.payment),
                            label: const Text('বিকাশ / নগদ দিয়ে জমা দিন'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _row(String title, String price) {
    return ListTile(
      title: Text(title),
      trailing: Text(price,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস & মূল্য তালিকা'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            '🍽️ খাবারের মূল্য তালিকা',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _row('শুধু সকাল', '৳ ১৫'),
                const Divider(height: 1),
                _row('শুধু দুপুর', '৳ ৩৫'),
                const Divider(height: 1),
                _row('শুধু রাত', '৳ ৩০'),
                const Divider(height: 1),
                _row('দুপুর + রাত', '৳ ৬০'),
                const Divider(height: 1),
                _row('সকাল + দুপুর', '৳ ৫০'),
                const Divider(height: 1),
                _row('সকাল + রাত', '৳ ৪৫'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
