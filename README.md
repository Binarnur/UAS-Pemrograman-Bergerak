# Nama: Binar Nur Alimin
# Kelas: TIF7/D
# NIM: 2205101093

# Proyek Mobile Programming - Smart Wellness Tracker
# ![alt text](https://github.com/Binarnur/My-aplikasi/blob/main/pic2.png.png?raw=true)
# ![alt text](https://github.com/Binarnur/My-aplikasi/blob/main/pic1.png.png?raw=true)  
# ![alt text](https://github.com/Binarnur/My-aplikasi/blob/main/pic.png.png?raw=true)
# pubspec.yaml
# ![alt text](https://github.com/Binarnur/My-aplikasi/blob/main/pic3.png?raw=true)
# lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wellness_tracker/screens/dashboard_screen.dart';
import 'package:smart_wellness_tracker/screens/ai_assistant_screen.dart';
import 'package:smart_wellness_tracker/screens/analytics_screen.dart';
import 'package:smart_wellness_tracker/services/storage_service.dart';
import 'package:smart_wellness_tracker/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wellness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const AIAssistantScreen(),
    const AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'AI Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}
# lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_wellness_tracker/widgets/activity_card.dart';
import 'package:smart_wellness_tracker/widgets/goal_card.dart';
import 'package:smart_wellness_tracker/models/health_data.dart';
import 'package:smart_wellness_tracker/services/storage_service.dart';
import 'package:smart_wellness_tracker/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  HealthData healthData = HealthData(
    steps: 6543,
    water: 6,
    sleep: 7.5,
    calories: 1850,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await StorageService.getHealthData();
    if (data != null) {
      setState(() => healthData = data);
    }
  }

  void _updateActivity(String type, num value) {
    setState(() {
      switch (type) {
        case 'steps':
          healthData.steps += value.toInt();
          break;
        case 'water':
          healthData.water += value.toInt();
          break;
        case 'sleep':
          healthData.sleep += value.toDouble();
          break;
        case 'calories':
          healthData.calories += value.toInt();
          break;
      }
    });
    StorageService.saveHealthData(healthData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang 👋',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Wellness Tracker',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.person, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Activity Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aktivitas Hari Ini',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickStat(
                                Icons.directions_walk,
                                '${healthData.steps}',
                                'langkah',
                              ),
                              _buildQuickStat(
                                Icons.water_drop,
                                '${healthData.water}',
                                'gelas',
                              ),
                              _buildQuickStat(
                                Icons.bedtime,
                                '${healthData.sleep}',
                                'jam',
                              ),
                              _buildQuickStat(
                                Icons.local_fire_department,
                                '${healthData.calories}',
                                'kcal',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateActivity('steps', 100),
                        icon: const Icon(Icons.add),
                        label: const Text('Langkah'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateActivity('water', 1),
                        icon: const Icon(Icons.add),
                        label: const Text('Air'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Goals Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Harian',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GoalCard(
                      icon: Icons.directions_walk,
                      title: '10.000 Langkah/Hari',
                      current: healthData.steps,
                      target: 10000,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    GoalCard(
                      icon: Icons.water_drop,
                      title: '8 Gelas Air/Hari',
                      current: healthData.water,
                      target: 8,
                      color: Colors.cyan,
                    ),
                    const SizedBox(height: 10),
                    GoalCard(
                      icon: Icons.bedtime,
                      title: '8 Jam Tidur',
                      current: healthData.sleep.toInt(),
                      target: 8,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 10),
                    GoalCard(
                      icon: Icons.local_fire_department,
                      title: 'Bakar 2000 Kalori',
                      current: healthData.calories,
                      target: 2000,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
# lib/screens/ai_assistant_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_wellness_tracker/services/ai_service.dart';
import 'package:smart_wellness_tracker/constants/colors.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final AIService _aiService = AIService();
  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'content': 'Halo! Saya asisten kesehatan AI Anda. Bagaimana saya bisa membantu Anda hari ini?'
    }
  ];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final response = await _aiService.getHealthAdvice(userMessage);
      setState(() {
        _messages.add({'role': 'assistant', 'content': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Maaf, terjadi kesalahan. Silakan coba lagi.'
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.pink.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tanya saya tentang kesehatan Anda 🤖',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return _buildLoadingIndicator();
                  }
                  
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        gradient: isUser
                            ? LinearGradient(
                                colors: [Colors.blue.shade500, Colors.blue.shade600],
                              )
                            : null,
                        color: isUser ? null : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15).copyWith(
                          bottomRight: isUser ? const Radius.circular(0) : null,
                          bottomLeft: !isUser ? const Radius.circular(0) : null,
                        ),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Suggested Questions
            if (!_isLoading)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💡 Contoh Pertanyaan:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          'Tips tidur lebih baik?',
                          'Olahraga apa yang cocok?',
                          'Berapa kalori ideal?',
                        ].map((q) => ActionChip(
                          label: Text(q, style: const TextStyle(fontSize: 11)),
                          onPressed: () {
                            _controller.text = q;
                            _sendMessage();
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Input Field
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ketik pertanyaan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade500, Colors.pink.shade500],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mengetik...',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
# lib/models/health_data.dart
class HealthData {
  int steps;
  int water;
  double sleep;
  int calories;

  HealthData({
    required this.steps,
    required this.water,
    required this.sleep,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'steps': steps,
    'water': water,
    'sleep': sleep,
    'calories': calories,
  };

  factory HealthData.fromJson(Map<String, dynamic> json) => HealthData(
    steps: json['steps'] ?? 0,
    water: json['water'] ?? 0,
    sleep: json['sleep']?.toDouble() ?? 0.0,
    calories: json['calories'] ?? 0,
  );
}
# lib/services/ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  Future<String> getHealthAdvice(String question) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1000,
          'system': 'Anda adalah asisten kesehatan AI yang ramah dan informatif. Berikan saran kesehatan dalam bahasa Indonesia yang singkat dan praktis.',
          'messages': [
            {'role': 'user', 'content': question}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      return 'Maaf, terjadi kesalahan dalam menghubungi AI assistant. Error: $e';
    }
  }
}
# lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_wellness_tracker/models/health_data.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const String _healthDataKey = 'health_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveHealthData(HealthData data) async {
    final jsonString = jsonEncode(data.toJson());
    await _prefs?.setString(_healthDataKey, jsonString);
  }

  static Future<HealthData?> getHealthData() async {
    final jsonString = _prefs?.getString(_healthDataKey);
    if (jsonString == null) return null;
    
    final jsonMap = jsonDecode(jsonString);
    return HealthData.fromJson(jsonMap);
  }

  static Future<void> clearData() async {
    await _prefs?.remove(_healthDataKey);
  }
}
# lib/widgets/goal_card.dart
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int current;
  final int target;
  final Color color;

  const GoalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (current / target * 100).clamp(0, 100);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors
# lib/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF06B6D4);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color background = Color(0xFFF9FAFB);
  static const Color text = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);
}
