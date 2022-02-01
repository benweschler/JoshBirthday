import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style.dart';
import 'coupon.dart';

class CouponView extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback setRedeemed;

  const CouponView({
    Key? key,
    required this.coupon,
    required this.setRedeemed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).cardColor;
    final TextStyle small = TextStyles.h1.copyWith(color: textColor);
    final TextStyle large = TextStyles.title.copyWith(color: textColor);

    final List<String> textRows = [
      "This super duper official coupon entitles",
      "Mr. Fluffy",
      "to",
      coupon.name,
      "from",
      coupon.sender,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        actions: coupon.description != null
            ? [
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(coupon.name),
                      content: Text(coupon.description!),
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
              ]
            : null,
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
                            style:
                                textRows.indexOf(row) % 2 == 0 ? small : large,
                            textAlign: TextAlign.center,
                          ))
                      .expand(
                          (element) => [element, SizedBox(height: Insets.med)])
                      .toList(),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: textColor),
                  child: Padding(
                    padding: EdgeInsets.all(Insets.med),
                    child: Text(
                      "Redeem",
                      style: TextStyles.subtitle,
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Redeem this coupon?'),
                      content:
                          const Text('Redeeming coupons can\'t be undone!'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text('Redeem'),
                          onPressed: () async {
                            setRedeemed();
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool(coupon.name, true);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                    barrierDismissible: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
