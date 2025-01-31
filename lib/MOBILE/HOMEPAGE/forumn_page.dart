import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final List<Map<String, dynamic>> forumTopics = [
    {
      "title": "How to learn Flutter?",
      "author": "Alice Johnson",
      "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      "comments": 12,
      "time": "2h ago"
    },
    {
      "title": "State Management: Provider vs Riverpod",
      "author": "John Doe",
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "comments": 8,
      "time": "3h ago"
    },
    {
      "title": "Best UI Practices in Flutter",
      "author": "Emma Brown",
      "avatar": "https://randomuser.me/api/portraits/women/55.jpg",
      "comments": 15,
      "time": "1d ago"
    },
    {
      "title": "Is Flutter good for Web Development?",
      "author": "Michael Scott",
      "avatar": "https://randomuser.me/api/portraits/men/47.jpg",
      "comments": 5,
      "time": "5h ago"
    },
    {
      "title": "How to optimize Flutter performance?",
      "author": "Sarah Parker",
      "avatar": "https://randomuser.me/api/portraits/women/60.jpg",
      "comments": 20,
      "time": "3d ago"
    },
    {
      "title": "Flutter vs React Native in 2024",
      "author": "Robert Downey",
      "avatar": "https://randomuser.me/api/portraits/men/52.jpg",
      "comments": 10,
      "time": "6h ago"
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Community Forum",
          style: FontFamily.styleb.copyWith(color: Colors.white),
        ),
        leading: const Icon(Icons.forum,color: Colors.white,),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(child: Text("No Data to Reflect",)),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: TextField(
      //         decoration: InputDecoration(
      //           hintText: "Search topics...   ",
      //           prefixIcon: const Icon(Icons.search),
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(30),
      //             borderSide: BorderSide.none,
      //           ),
      //           filled: true,
      //           fillColor: Colors.grey[200],
      //         ),
      //         onChanged: (query) {
      //           setState(() {
      //             searchQuery = query.toLowerCase();
      //           });
      //         },
      //       ),
      //     ),
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: forumTopics.length,
      //         itemBuilder: (context, index) {
      //           var topic = forumTopics[index];
      //           if (!topic["title"].toLowerCase().contains(searchQuery)) {
      //             return const SizedBox();
      //           }
      //           return Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             elevation: 3,
      //             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      //             child: ListTile(
      //               leading: CircleAvatar(
      //                 backgroundImage: NetworkImage(topic["avatar"]),
      //               ),
      //               title: Text(
      //                 topic["title"],
      //                 style: const TextStyle(fontWeight: FontWeight.bold),
      //               ),
      //               subtitle: Text(
      //                 "by ${topic["author"]} • ${topic["time"]}",
      //                 style: TextStyle(color: Colors.grey[600], fontSize: 12),
      //               ),
      //               trailing: Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   const Icon(Icons.comment, color: Colors.blueAccent),
      //                   const SizedBox(width: 5),
      //                   Text("${topic["comments"]}"),
      //                 ],
      //               ),
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => DiscussionDetailPage(topic: topic),
      //                   ),
      //                 );
      //               },
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTopicDialog();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTopicDialog() {
    TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Topic"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "Enter topic title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  forumTopics.add({
                    "title": titleController.text,
                    "author": "New User",
                    "avatar": "https://randomuser.me/api/portraits/men/99.jpg",
                    "comments": 0,
                    "time": "Just now",
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }
}

class DiscussionDetailPage extends StatelessWidget {
  final Map<String, dynamic> topic;

  const DiscussionDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic["title"]),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(topic["avatar"]),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic["author"],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      topic["time"],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Discussion about: ${topic["title"]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {},
                label: const Text("Reply"),
                icon: const Icon(Icons.reply),
                backgroundColor: Colors.blueAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
