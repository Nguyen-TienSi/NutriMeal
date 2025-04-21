import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_post_data.dart' show PostData;
import 'user_post.dart' show UserPost;

class SocialPostScreen extends StatefulWidget {
  const SocialPostScreen({super.key});

  @override
  State<SocialPostScreen> createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  final List<PostData> posts = [
    PostData(
      username: 'Bob',
      timePosted: '3h ago',
      postImage: 'assets/images/lunch.jpg',
      caption: 'Salad life 🥗',
    ),
    PostData(
      username: 'Alice',
      timePosted: '1h ago',
      postImage: 'assets/images/breakfast.jpg',
      caption: 'Yummy oatmeal!',
    ),
    PostData(
      username: 'JohnDoe',
      timePosted: '2 hours ago',
      postImage: 'assets/images/dinner.jpg',
      caption: 'Loving this healthy dish!',
    ),
    PostData(
      username: '@foodie_lover123',
      timePosted: '51d',
      postImage: 'assets/images/dish.jpg',
      caption: 'This burrito was epic!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return UserPost(
            username: post.username,
            timePosted: post.timePosted,
            postImage: post.postImage,
            caption: post.caption,
          );
        },
      ),
    );
  }
}
