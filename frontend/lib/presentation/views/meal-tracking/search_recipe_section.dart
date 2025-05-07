import 'package:flutter/material.dart';

class SearchRecipeSection extends StatefulWidget {
  const SearchRecipeSection({super.key});

  @override
  State<SearchRecipeSection> createState() => _SearchRecipeSectionState();
}

class _SearchRecipeSectionState extends State<SearchRecipeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Search Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: 0, // Replace with actual search results
            itemBuilder: (context, index) {
              return const ListTile(
                title: Text('Recipe Name'),
                subtitle: Text('Calories: 0'),
              );
            },
          ),
        ),
      ],
    );
  }
}
