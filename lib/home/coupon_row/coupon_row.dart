import 'package:floof/home/coupon_row/coupon_card.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponRow extends StatefulWidget {
  final List<Coupon> coupons = const [
    Coupon('EXTREME PIGGYBACKING', 'Zach and Ben', 1),
    Coupon('British Morning Butler Service', 'Zach and Ben', 2),
    Coupon('Deep Tissue Joint-Jostling', 'Ben', 3),
    Coupon('Sir Buffness Bootcamp', 'Zach', 4),
    Coupon('A Bowl of Soup, a Slab O\' Fish, and Thou', 'Mom', 5),
    Coupon('Make Your Fingertips Sparkle', 'Mom', 6),
    Coupon('The Best Kind of Brain Freeze', 'Mom and Dad', 7),
    Coupon('Break a Date with the Dishwasher', 'Mom and Dad', 8),
    Coupon('Premium Back Scritchies', 'Mom and Dad', 9),
    Coupon('Amateur Mani Night', 'Mom', 10),
    Coupon('A Personal Housecleaner', 'Mom and Dad', 11),
    Coupon('Trash Me in a Game of Your Choice', 'Ben', 12),
    Coupon('A Morsel Pu Pu Platter', 'Mom', 13),
    Coupon('I\'ll Respond to "Person Who Has No Friends" for a Day', 'Ben', 14),
    Coupon('A Pu Pu Morsel Platter', 'Mom', 15),
    Coupon('A Haiku for You\nIs What This Haicoupon\'ll Do', 'Zach and Ben, to You', 16),
    Coupon('A Singular Meow', 'Zen Master Topaz', 17),
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
