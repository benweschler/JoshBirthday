import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floof/home/coupon_row/coupon_card.dart';
import 'package:floof/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/style.dart';
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
    final Color textColor = Theme.of(context).colorScheme.primary;
    final TextStyle smallStyle = TextStyles.body.copyWith(color: textColor);
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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                _buildRedeemButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRedeemButton(BuildContext context) {
    return ElevatedButton(
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
                final firebase = FirebaseFirestore.instance;

                // Only allow coupon redemption when online
                if (!(await isConnectedToInternet())) {
                  _showNetworkErrorSnackBar(context);
                }
                // This page can be reachable and current coupon can be disabled
                // in Firebase if the coupon was disabled, but not through this
                // instance of the app, and this app was bootstrapped while
                // offline.
                else if ((await firebase.doc('coupons/coupons').get())
                        .get('${coupon.firestoreID}') == false) {
                  final prefs = await SharedPreferences.getInstance();
                  // set the local coupon cache to match firebase.
                  prefs.setBool(coupon.title, false);
                  Navigator.pop(context);
                  _showInvalidCouponDialog(context);
                } else if (AccessVersion.version ==
                    (await firebase.doc('app_id/version').get())
                        .get('required_version') as String) {
                  // Set coupon to redeemed in Firestore.
                  // If firestore can't be reached, don't redeem.
                  await firebase
                      .collection('coupons')
                      .doc('coupons')
                      .update({'${coupon.firestoreID}': false})
                      .then((_) async =>
                          await _redeemCoupon(context, coupon, disableCoupon))
                      .catchError((_) => _showNetworkErrorSnackBar(context));
                }
                // This will also trigger if the app version could not be
                // retrieved from Firestore due to Josh's sneaky pause wifi trick.
                else {
                  Navigator.pop(context);
                  _showOutdatedAppDialog(context);
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
    Color textColor = Theme.of(context).colorScheme.primary;

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
          style: TextStyles.body.copyWith(
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInvalidCouponDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("WHY YOUUU TRICKY DOG"),
        content: const Text("Why don't you look at that... You were trying to "
            "trick me and get some free coupons! Well guess what? I'm smarter "
            "than you and you got caught and you also have no friends you "
            "absolute nincompoop. Get wrecked m8. Now go restart the app like a "
            "good little boy."),
        actions: [
          TextButton(
            child: const Text("Accept Your Lameness"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showNetworkErrorSnackBar(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'You need to be connected to the internet to redeem a coupon.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showOutdatedAppDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: const Text(
                  'It looks like you\'re using an outdated version'
                  ' of the app. Update to the latest version in order to redeem'
                  ' coupons.'),
              actions: [
                TextButton(
                  child: const Text('Got It'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
