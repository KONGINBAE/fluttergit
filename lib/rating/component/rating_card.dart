import 'package:actual/common/const/colors.dart';
import 'package:actual/rating/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarimage;
  final List<Image> images;
  final int rating;
  final String email;

  //리뷰내용
  final String content;

  const RatingCard({required this.avatarimage,
    required this.images,
    required this.rating,
    required this.email,
    //리뷰내용
    required this.content,
    Key? key})
      : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model,
  }) {
    return RatingCard(
      avatarimage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,);
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarimage: avatarimage,
          email: email,
          rating: rating,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarimage;
  final int rating;
  final String email;

  const _Header({required this.avatarimage,
    required this.rating,
    required this.email,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarimage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        ...List.generate(
            5,
                (index) =>
                Icon(
                  index < rating ? Icons.star : Icons.star_border_outlined,
                  color: PRIMARY_COLOR,
                )),
        //Icon(Icons.star)
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed((index, e) =>
          Padding(
            padding: EdgeInsets.only(
                right: index == images.length - 1 ? 0 : 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: e,
            ),
          ))
          .toList(),
    );
  }
}
