import 'package:floof/home/coupon_row/coupon_card.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart';
import 'coupon_list.dart';

class CouponRow extends StatelessWidget {
  const CouponRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
          children: [
        for (int i = 0; i < CouponList.coupons.length; i++)
          CouponCard(
            coupon: CouponList.coupons[i],
          )
      ].expand((element) => [element, SizedBox(width: Insets.med)]).toList()),
    );
  }
}
