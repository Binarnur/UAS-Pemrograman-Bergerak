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
