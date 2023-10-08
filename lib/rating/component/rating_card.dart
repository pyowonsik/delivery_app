import 'package:delivery_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage;
  final List<Image> imges;
  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {super.key,
      required this.avatarImage,
      required this.imges,
      required this.rating,
      required this.email,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avatarImage: avatarImage, email: email, rating: rating),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (imges.isNotEmpty)
          SizedBox(
            height: 100,
            child: _Image(
              images: imges,
            ),
          )
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;
  const _Header(
      {super.key,
      required this.avatarImage,
      required this.email,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
        ...List.generate(
          5,
          (index) => index < rating
              ? const Icon(Icons.star, color: PRIMARY_COLOR)
              : const Icon(
                  Icons.star_outline_outlined,
                  color: PRIMARY_COLOR,
                ),
        )
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(child: Text(content)),
    ]);
  }
}

class _Image extends StatelessWidget {
  final List<Image> images;
  const _Image({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed((index, e) => Padding(
                padding: EdgeInsets.only(
                    right: index == images.length - 1 ? 0 : 16.0),
                child: e,
              ))
          .toList(),
    );
  }
}
