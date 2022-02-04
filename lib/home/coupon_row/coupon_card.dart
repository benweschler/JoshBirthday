import 'package:floof/home/coupon_row/coupon_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  static const Color couponColor = Color(0xFFFFDB51);

  const CouponCard({
    Key? key,
    required this.coupon,
  }) : super(key: key);

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isActive = true;

  @override
  void initState() {
    checkRedeemed();
    super.initState();
  }

  void checkRedeemed() async {
    final prefs = await SharedPreferences.getInstance();
    bool? couponIsRedeemed = prefs.getBool(widget.coupon.title);
    setState(() {
      if(couponIsRedeemed != null) {
        isActive = prefs.getBool(widget.coupon.title)!;
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              title: Text('Disaster!!!'),
              content: Text(
                  'I ran into a critical error :(. Make sure to let Ben '
                  'know about this so he can get you up and running again!'
                  '\n\nError: Local coupon cache was missing a coupon key.'),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(Insets.med),
        decoration: BoxDecoration(
          color: isActive ? CouponCard.couponColor : Colors.grey.shade400,
          borderRadius: Corners.medBorderRadius,
        ),
        child: Center(
          child: Text(
            widget.coupon.title,
            style: TextStyle(
              fontSize: 20,
              color:
                  isActive ? Theme.of(context).cardColor : Colors.grey.shade800,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onTap: isActive
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CouponView(
                    coupon: widget.coupon,
                    disableCoupon: () => setState(() => isActive = false),
                  ),
                ),
              )
          : null,
    );
  }
}
