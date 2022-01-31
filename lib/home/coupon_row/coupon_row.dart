import 'package:floof/home/coupon_row/coupon_card.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponRow extends StatefulWidget {
  final List<Coupon> coupons = const [
    Coupon('EXTREME PIGGYBACKING', 'Zach and Ben'),
    Coupon('British Morning Butler Service', 'Zach and Ben'),
    Coupon('Deep Tissue Joint-Jostling', 'Ben'),
    Coupon('A Bowl of Soup, a Slab of Fish, and Thou', 'Mom'),
    Coupon('Break a Date with the Dishwasher', 'Mom and Dad'),
    Coupon('Premium Back Scritchies', 'Mom and Dad'),
    Coupon('Sir Buffness Bootcamp', 'Zach'),
    Coupon('A Mani-Pedi (minus the pedi)', 'Mom'),
    Coupon('Absolutely Trash Me in Rocket League', 'Ben'),
    Coupon('Call Me "Person Who Has No Friends" for a Day and I\'ll Respond', 'Ben'),
    Coupon('A Gourmet Morsel Platter', 'Mom'),
    Coupon('A Haiku for You\nIs what this Haicoupon\'ll Do', 'Zach and Ben, to You'),
    Coupon('A Singular Meow', 'Zen Master Topaz'),
  ];

  const CouponRow({Key? key}) : super(key: key);

  @override
  State<CouponRow> createState() => _CouponRowState();
}

class _CouponRowState extends State<CouponRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
          children: [
        for (int i = 0; i < widget.coupons.length; i++)
          CouponCard(
            coupon: widget.coupons[i],
          )
      ]
              .expand((element) => [
                    element,
                    SizedBox(
                      width: Insets.med,
                    )
                  ])
              .toList()),
    );
  }
}
