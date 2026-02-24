import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Dummy Upcoming Items
  final List<Map<String, dynamic>> upcomingShows = [
    {
      'title': 'The Awakening',
      'date': 'Coming Friday',
      'description': 'A new series exploring faith in the modern world.',
      'imageUrl':
          'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=800&q=80',
      'reminded': false,
    },
    {
      'title': 'Global Missions 2026',
      'date': 'Coming Next Month',
      'description':
          'Follow the journey of missionaries across the globe in this exclusive documentary.',
      'imageUrl':
          'https://images.unsplash.com/photo-1529070538774-1843cb3265df?w=800&q=80',
      'reminded': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New & Hot'),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: upcomingShows.length,
        itemBuilder: (context, index) {
          final show = upcomingShows[index];
          return _buildUpcomingItem(show, index);
        },
      ),
    );
  }

  Widget _buildUpcomingItem(Map<String, dynamic> show, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated Video / Trailer Player Area
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(show['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 60,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    show['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildActionButton(
                  icon: show['reminded']
                      ? Icons.check
                      : Icons.notifications_none,
                  label: 'Remind Me',
                  onTap: () {
                    setState(() {
                      show['reminded'] = !show['reminded'];
                    });
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Info',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  show['date'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  show['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Inspiring • Emotional • Faith-based',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
}
