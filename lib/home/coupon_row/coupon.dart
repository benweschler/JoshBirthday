import 'package:flutter/material.dart';

class Coupon {
  final String title;
  final String sender;
  final int firestoreID;
  // Use a callback that provides a BuildContext to build URLs in the
  // description with the Theme.of(context).colorScheme.primary color.
  final List<TextSpan> Function(BuildContext) buildDescription;

  const Coupon(
    this.title,
    this.sender,
    this.firestoreID,
    this.buildDescription,
  );
}
