import 'package:flutter/material.dart';

class AddBox extends StatelessWidget {
  final String imageUrl;
  const AddBox({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
