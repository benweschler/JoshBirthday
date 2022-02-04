import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floof/home/coupon_row/coupon_card.dart';
import 'package:floof/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponView extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback disableCoupon;

  const CouponView({
    Key? key,
    required this.coupon,
    required this.disableCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).cardColor;
    final TextStyle smallStyle = TextStyles.h1.copyWith(color: textColor);
    final TextStyle largeStyle = TextStyles.title.copyWith(color: textColor);

    final List<String> textRows = [
      "This super duper official coupon entitles",
      "Mr. Fluffy",
      "to",
      coupon.title,
      "from",
      coupon.sender,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  coupon.title,
                  style:
                      TextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
                ),
                content: Text.rich(
                  TextSpan(children: coupon.description),
                  // make the haiku description centered :)
                  textAlign: coupon.firestoreID == 15
                      ? TextAlign.center
                      : TextAlign.start,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.offset),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: textRows
                      .map((row) => Text(
                            row,
                            style: textRows.indexOf(row) % 2 == 0
                                ? smallStyle
                                : largeStyle,
                            textAlign: TextAlign.center,
                          ))
                      .expand(
                          (element) => [element, SizedBox(height: Insets.med)])
                      .toList(),
                ),
                const SizedBox(height: 80),
                _buildRedeemButton(context, textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRedeemButton(BuildContext context, Color buttonColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: buttonColor),
      child: Padding(
        padding: EdgeInsets.all(Insets.med),
        child: Text(
          "Redeem",
          style: TextStyles.subtitle,
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: const Text('Redeem this coupon?'),
          content: const Text('Redeeming coupons can\'t be undone!'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Redeem'),
              onPressed: () async {
                // Only allow coupon redemption when online
                if (!(await isConnectedToInternet())) {
                  _showErrorSnackbar(context);
                } else {
                  //TODO: test this
                  // Set coupon to redeemed in Firestore.
                  // If firestore can't be reached, don't redeem.
                  await FirebaseFirestore.instance
                      .collection('coupons')
                      .doc('${coupon.firestoreID}')
                      .update({'isActive': false})
                      .then((_) async =>
                          await _redeemCoupon(context, coupon, disableCoupon))
                      .catchError((_) => _showErrorSnackbar(context));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _redeemCoupon(
      BuildContext context, Coupon coupon, VoidCallback disableCoupon) async {
    // grey out coupon on home page
    disableCoupon();

    // set coupon to redeemed in local cache
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(coupon.title, false);

    Navigator.pop(context);
    _showRedeemedCard(context, coupon);
  }

  void _showRedeemedCard(BuildContext context, Coupon coupon) {
    Color textColor = Theme.of(context).cardColor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: CouponCard.couponColor,
        title: Text(
          "Redeemed:\n${coupon.title}",
          textAlign: TextAlign.center,
          style: TextStyles.subtitle.copyWith(
            color: textColor,
          ),
        ),
        content: Text(
          'Gimme my stuff!',
          textAlign: TextAlign.center,
          style: TextStyles.h1.copyWith(
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: Text(
              'Close',
              style: TextStyle(color: textColor),
            ),
          )
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'You need to be connected to the internet to redeem a coupon.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
