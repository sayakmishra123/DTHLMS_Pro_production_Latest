import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackupVideosPage extends StatefulWidget {
  const BackupVideosPage({super.key});

  @override
  State<BackupVideosPage> createState() => _BackupVideosPageState();
}

class _BackupVideosPageState extends State<BackupVideosPage> {
  final List<Map<String, String>> videos = [
    {
      'title': 'System Backup Guide',
      'duration': '15:42',
      'thumbnail': 'https://randomuser.me/api/portraits/women/44.jpg',
      'category': 'Backup Essentials',
      'package': 'System Security',
    },
    {
      'title': 'Cloud Storage Overview',
      'duration': '12:30',
      'thumbnail': 'https://randomuser.me/api/portraits/women/44.jpg',
      'category': 'Cloud Solutions',
      'package': 'Data Management',
    },
    {
      'title': 'Automated Backup Strategies',
      'duration': '10:05',
      'thumbnail': 'https://randomuser.me/api/portraits/women/44.jpg',
      'category': 'Automation',
      'package': 'Smart Backups',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Backup Videos',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    video['thumbnail']!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  video['title']!,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration: ${video['duration']}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Category: ${video['category']}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      'Package: ${video['package']}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.blueAccent,
                  size: 32,
                ),
                onTap: () {
                  // Video playback logic here
                },
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
