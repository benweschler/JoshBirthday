import 'package:flutter/material.dart';

class Coupon {
  final String title;
  final String sender;
  final int firestoreID;
  final List<TextSpan> description;

  const Coupon(this.title, this.sender, this.firestoreID, this.description);
}