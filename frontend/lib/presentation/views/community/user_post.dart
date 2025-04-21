import 'package:flutter/material.dart';

class UserPost extends StatelessWidget {
  final String username;
  final String timePosted;
  final String postImage;
  final String caption;

  const UserPost({
    super.key,
    required this.username,
    required this.timePosted,
    required this.postImage,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/dish.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          timePosted,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Image.asset(
              postImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              caption,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {},
                    ),
                    const Text('Like'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    const Text('Comment'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    const Text('Share'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
