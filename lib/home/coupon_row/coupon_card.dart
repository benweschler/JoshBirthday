import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floof/home/coupon_row/coupon_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;

  const CouponCard({
    Key? key,
    required this.coupon,
  }) : super(key: key);

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isRedeemed = false;

  @override
  void initState() {
    checkRedeemed();
    super.initState();
  }

  void checkRedeemed() async {
    //TODO: Firebase Debugging
    /**************************************************************************/
    CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');
    var couponsDoc = await coupons.doc('coupons').get();
    Map<String, dynamic> dataMap = couponsDoc.data() as Map<String, dynamic>;
    print(dataMap['${widget.coupon.fireStoreID}']);
    /**************************************************************************/

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(widget.coupon.title) != null) {
      setState(() => isRedeemed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(Insets.med),
        decoration: BoxDecoration(
          color: isRedeemed ? Colors.grey.shade400 : const Color(0xFFFFDB51),
          borderRadius: Corners.medBorderRadius,
        ),
        child: Center(
          child: Text(
            widget.coupon.title,
            style: TextStyle(
              fontSize: 20,
              color: isRedeemed
                  ? Colors.grey.shade800
                  : Theme.of(context).cardColor,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onTap: isRedeemed
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CouponView(
                    coupon: widget.coupon,
                    setRedeemed: () => setState(() => isRedeemed = true),
                  ),
                ),
              ),
    );
  }
}
