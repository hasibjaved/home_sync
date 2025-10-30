import 'package:flutter/material.dart';

class HealthStatusDialog extends StatelessWidget {
  final Function(String status) onStatusSelected;

  const HealthStatusDialog({super.key, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple.shade300],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.favorite_rounded, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'How are you today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Let us know your current status',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Health Options
            _buildHealthOption(
              context,
              icon: Icons.sentiment_very_satisfied_rounded,
              label: 'Healthy',
              color: Colors.green,
              onTap: () => _selectStatus(context, 'healthy'),
            ),
            const SizedBox(height: 12),
            _buildHealthOption(
              context,
              icon: Icons.sick_rounded,
              label: 'Sick',
              color: Colors.orange,
              onTap: () => _selectStatus(context, 'sick'),
            ),
            const SizedBox(height: 12),
            _buildHealthOption(
              context,
              icon: Icons.work_off_rounded,
              label: 'Busy',
              color: Colors.blue,
              onTap: () => _selectStatus(context, 'busy'),
            ),
            const SizedBox(height: 12),
            _buildHealthOption(
              context,
              icon: Icons.flight_takeoff_rounded,
              label: 'Away',
              color: Colors.purple,
              onTap: () => _selectStatus(context, 'away'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: (color is MaterialColor) ? color.shade700 : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _selectStatus(BuildContext context, String status) {
    onStatusSelected(status);
    Navigator.pop(context);
  }
}
