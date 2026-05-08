import 'package:flutter/material.dart';
import 'servives/history_service.dart';
import 'package:intl/intl.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final darkBackground = theme.scaffoldBackgroundColor;
    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: surfaceColor,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'BORD TABLE',
          style: TextStyle(
            color: primaryColor, // Lime color
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder<List<HistoryEntry>>(
        future: HistoryService().getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allHistory = snapshot.data ?? [];
          
          // Statistiques globales
          final totalReps = allHistory.fold(0, (sum, e) => sum + e.reps);
          final totalCalories = (totalReps * 0.5).toInt();
          final totalDuration = allHistory.fold(0, (sum, e) => sum + e.durationMinutes);
          
          final streak = _calculateStreak(allHistory);
          final weeklyActivity = _calculateWeeklyActivity(allHistory);

          // Statistiques du jour sélectionné
          final selectedDayHistory = allHistory.where((e) {
            final date = DateTime.parse(e.date);
            return date.year == _selectedDate.year &&
                date.month == _selectedDate.month &&
                date.day == _selectedDate.day;
          }).toList();

          final dayReps = selectedDayHistory.fold(0, (sum, e) => sum + e.reps);
          final dayCalories = (dayReps * 0.5).toInt();
          final dayDuration = selectedDayHistory.fold(0, (sum, e) => sum + e.durationMinutes);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Weekly Activity (Selection Box) ---
                _buildSectionTitle("Activités de la semaine", primaryColor),
                const SizedBox(height: 12),
                _buildWeeklyActivity(cardColor, primaryColor, weeklyActivity, textColor),
                
                const SizedBox(height: 24),

                // --- Selected Day Stats ---
                _buildSectionTitle("Statistiques du ${DateFormat('dd MMMM').format(_selectedDate)}", primaryColor),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard(cardColor, "Calories", "$dayCalories", "kcal", "Aujourd'hui", false, textColor, primaryColor: primaryColor),
                    const SizedBox(width: 12),
                    _buildStatCard(cardColor, "Répétitions", "$dayReps", "reps", "Aujourd'hui", false, textColor, primaryColor: primaryColor),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard(cardColor, "Temps total", "$dayDuration", "min", "Aujourd'hui", false, textColor, primaryColor: primaryColor),
                    const SizedBox(width: 12),
                    _buildStatCard(cardColor, "Série", "$streak", "jours", "en feu", false, textColor, icon: Icons.local_fire_department, primaryColor: primaryColor),
                  ],
                ),

                const SizedBox(height: 30),

                // --- Global Stats ---
                _buildSectionTitle("Statistiques globales", primaryColor),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildGlobalStatRow("Total calories", "$totalCalories kcal", primaryColor, textColor),
                      const Divider(color: Colors.white10),
                      _buildGlobalStatRow("Total répétitions", "$totalReps reps", primaryColor, textColor),
                      const Divider(color: Colors.white10),
                      _buildGlobalStatRow("Temps total", "$totalDuration min", primaryColor, textColor),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlobalStatRow(String label, String value, Color primaryColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14)),
          Text(value, style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildStatCard(Color cardColor, String title, String value, String unit, String label, bool showTrend, Color textColor, {IconData? icon, required Color primaryColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
                ),
                if (icon != null) ...[
                  const Spacer(),
                  Icon(icon, color: Colors.orange, size: 20),
                ]
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: showTrend ? Colors.green.withOpacity(0.1) : textColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: showTrend ? Colors.green : textColor.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyActivity(Color cardColor, Color primaryColor, List<Map<String, dynamic>> activity, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: activity.map((day) {
          final isSelected = day['date'].year == _selectedDate.year &&
              day['date'].month == _selectedDate.month &&
              day['date'].day == _selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day['date'];
              });
            },
            child: Column(
              children: [
                Text(
                  day['label'],
                  style: TextStyle(
                    color: isSelected ? primaryColor : textColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? primaryColor 
                        : (day['active'] ? primaryColor.withOpacity(0.2) : textColor.withOpacity(0.05)),
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: primaryColor, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(day['date']),
                      style: TextStyle(
                        color: isSelected ? Colors.black : textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (day['active'] && !isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _calculateWeeklyActivity(List<HistoryEntry> history) {
    final today = DateTime.now();
    final List<Map<String, dynamic>> activity = [];
    
    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final hasActivity = history.any((e) {
        final date = DateTime.parse(e.date);
        return date.year == day.year && date.month == day.month && date.day == day.day;
      });
      
      activity.add({
        'label': DateFormat('E').format(day).substring(0, 1),
        'active': hasActivity,
        'date': day,
      });
    }
    return activity;
  }

  int _calculateStreak(List<HistoryEntry> history) {
    if (history.isEmpty) return 0;
    int streak = 0;
    DateTime checkDate = DateTime.now();
    
    // Vérifier si activité aujourd'hui
    bool hasActivityToday = history.any((e) {
      final date = DateTime.parse(e.date);
      return date.year == checkDate.year && date.month == checkDate.month && date.day == checkDate.day;
    });

    // Si pas d'activité aujourd'hui, on vérifie à partir d'hier pour ne pas casser la série
    if (!hasActivityToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    while (true) {
      final hasActivity = history.any((e) {
        final date = DateTime.parse(e.date);
        return date.year == checkDate.year && date.month == checkDate.month && date.day == checkDate.day;
      });
      
      if (hasActivity) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
