import 'package:flutter/material.dart';
import 'package:storyapp_flutter/model/model.dart';
import 'package:storyapp_flutter/ui/login.dart';
import 'package:storyapp_flutter/utils/auth.dart';

import '../repo/repository.dart';
import 'add_story.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ListStory>> listStory;
  final Repository repository = Repository();
  // String? token = await AuthManager.getAuthToken();
  late String? token;

  Future<void> getToken() async {
    token = await AuthManager.getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "logout") {
                AuthManager.clearToken();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(Icons
                          .power_settings_new_rounded), // Icon untuk item 1
                      SizedBox(width: 8), // Spasi antara ikon dan teks
                      Text('Log Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ListStory>>(
        future: repository.getStory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<ListStory> stories = snapshot.data!;
            return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromARGB(255, 202, 200,
                                    200), // Warna latar belakang lingkaran
                                radius: 20, // Radius lingkaran
                                child: Icon(
                                  Icons.person, // Icon yang ingin ditampilkan
                                  size: 20, // Ukuran icon
                                  color: Colors.white, // Warna icon
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  story.name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_horiz_rounded))
                        ],
                      ),
                    ),
                    Image.network(story.photoUrl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.favorite_border_rounded)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.comment)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.ios_share_outlined)),
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_border))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            story.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(width: 2),
                          Text(story.description,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddStoryPage())));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
