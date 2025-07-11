import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> apps = [
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png',
        'name': 'Instagram',
        'time': '20 min',
        'right': '1h',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
        'name': 'Facebook',
        'time': '20 min',
        'right': '1h',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png',
        'name': 'Instagram',
        'time': '20 min',
        'right': '1h',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
        'name': 'Facebook',
        'time': '20 min',
        'right': '1h',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png',
        'name': 'Instagram',
        'time': '20 min',
        'right': '1h',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
        'name': 'Facebook',
        'time': '20 min',
        'right': '1h',
      },
    ];

    return Scaffold(
    
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Chart Card
            Container(
              height: 190,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6DC),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'Screen Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100, // تم زيادة الارتفاع
                    child: _FakeBarChart(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Apps List
            ...apps.map(
              (app) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            app['icon'],
                            fit: BoxFit.contain,
                            width: 32,
                            height: 32,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 32,
                                height: 32,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            app['time'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      app['right'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<double> yellowBars = [1.0, 2.0, 0.5, 0.2, 1.5, 0.7, 1.0];
    final List<double> blueBars = [2.5, 1.5, 2.0, 0.8, 0.8, 2.0, 2.2];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBarHeight = constraints.maxHeight - 20;
        final double maxBarValue = 5.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) {
            final double blueHeight =
                (blueBars[i] / maxBarValue) * maxBarHeight;
            final double yellowHeight =
                (yellowBars[i] / maxBarValue) * maxBarHeight;

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: blueHeight,
                    width: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF19202D),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    height: yellowHeight,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Color(0xFFFBB600),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[i],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
