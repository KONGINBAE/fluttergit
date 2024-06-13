import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  // 이미지
  final Widget image;
  //레스토랑 이름
  final String name;
  //레스토랑 태그
  final List<String> tags;
  //평점갯수수
  final int ratingsCount;
  //배송설리는 시간
  final int deliveryTime;
  //배송비용
  final int deliveryFee;
  //평균평점
  final double ratings;
  //상세 카드 여부
  final bool isDetail;

  final String? herokey;
  //상세내역
  final String? detail;
  const RestaurantCard(
      {required this.image,
      //레스토랑 이름
      required this.name,
      //레스토랑 태그
      required this.tags,
      //평점갯수수
      required this.ratingsCount,
      //배송설리는 시간
      required this.deliveryTime,
      //배송비용
      required this.deliveryFee,
      //평균평점
      required this.ratings,
      this.herokey,
      this.isDetail = false,
      this.detail,
      Key? key})
      : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      name: model.name,
      herokey: model.id,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (herokey != null)
          Hero(
            tag: ObjectKey(herokey),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
              child: image,
            ),
          ),
        if (herokey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        const SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tags.join(' · '),
              style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            _IconText(icon: Icons.star, label: ratings.toString()),
            renderDot(),
            _IconText(icon: Icons.receipt, label: ratingsCount.toString()),
            renderDot(),
            _IconText(icon: Icons.timelapse_outlined, label: '$deliveryTime 분'),
            renderDot(),
            _IconText(
                icon: Icons.monetization_on,
                label: deliveryFee == 0 ? '무료' : deliveryFee.toString()),
          ],
        ),
        if (detail != null && isDetail)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(detail!),
          ),
      ],
    );
  }
}

renderDot() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Text(
      '·',
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    ),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: PRIMARY_COLOR, size: 14.0),
        const SizedBox(width: 8.0),
        Text(label,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
