import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/style.dart';
import 'coupon.dart';

class CouponList {
  static List<Coupon> coupons = [
    Coupon('EXTREME PIGGYBACKING', 'Zach and Ben', 1, (context) => [_url(context, 'https://bit.ly/3gs8Yna')]),
    Coupon('British Morning Butler Service', 'Zach and Ben', 2, (context) => [_text('For only the most refined gentlemen.')]),
    Coupon('Deep Tissue Joint-Jostling', 'Ben', 3, (context) => [_text('Good for an AGGRESSIVELY* relaxing massage.\n\n\n'), _smallText("*Aggression up to user preference")]),
    Coupon('Sir Buffness Bootcamp', 'Zach', 4, (context) => [_text('Somewhere between this:\n'), _url(context, 'https://bit.ly/35O6jCu'), _text('\nand this:\n'), _url(context, 'https://bit.ly/37kBlmF'), _smallText('.\n\nOptional bonus: '), _smallUrl(context, 'https://bit.ly/3B0sTTN')]),
    Coupon('A Bowl of Soup, a Slab O\' Fish, and Thou', 'Mom', 5, (context) => [_text("Feeling meh about the leftovers on offer for dinner? Mom will take you out to your favorite Sushi place for a scrumptious sushi dinner with all the trimmings. Now that’s some good eatin'!")]),
    Coupon('Make Your Fingertips Sparkle', 'Mom', 6, (context) => [_text("Get those shnails shparkling with a (probably purple) professional makeover!")]),
    Coupon('The Best Kind of Brain Freeze', 'Mom and Dad', 7, (context) => [_text('Want to skip the desserts at home and get straight to the pint? Or maybe you just need some ice cream as soon as popsicle. Well it was mint to be, since it’s sherbert-hday! Good for a trip to the ice cream store!')]),
    Coupon('Break a Date with the Dishwasher', 'Mom and Dad', 8, (context) => [_text("Dishes suck. Don’t do them. Make parents do instead.")]),
    Coupon('Premium Back Scritchies', 'Mom and Dad', 9, (context) => [_text('they’re the SCRITCHIEST')]),
    Coupon('Amateur Mani Night', 'Mom', 10, (context) => [_text('Are your nails looking a little tired? No time for the salon? Mom will be at your service to paint your nails an array of amazing colors of your choice!')]),
    Coupon('A Personal Housecleaner', 'Mom and Dad', 11, (context) => [_text("Feel like being a slob and don’t want to clean up? Make mom and dad do it instead!")]),
    Coupon('Trash Me in a Game of Your Choice', 'Ben', 12, (context) => [_text("Need an ego boost? Crush a lowly n00b on your home court.")]),
    Coupon('A Morsel Pu Pu Platter', 'Mom', 13, (context) => [_text("PuPu Platter [Hawaiian]: A medley of appetizers.\n\nMorsels [Weschler] – Delectable little bits Mom makes with whatever she finds in the kitchen. They’re never the same twice, but whatever it ends up being it’ll be delish!")]),
    Coupon('I\'ll Respond to "Person Who Has No Friends" for a Day', 'Ben', 14, (context) => [_text("ugh.")]),
    Coupon('A Haiku for You\nIs What This Haicoupon\'ll Do', 'Zach and Ben, to You', 15, (context) => [_text("Josh gets a haiku\nFrom Zach and Ben, you get Two!\nRefrigerator")]),
    Coupon('A Singular Meow', 'Zen Master Topaz', 16, (context) => [_text("REQUIRED: ONE HEAD PAT")]),
  ];
}

TextSpan _text(String text) {
  return TextSpan(text: text, style: TextStyles.body);
}

TextSpan _smallText(String text) {
  return TextSpan(
    text: text,
    style: const TextStyle(fontSize: 10),
  );
}

TextSpan _url(BuildContext context, String url) {
  return TextSpan(
    text: url,
    style: TextStyles.body.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () => launch(url),
  );
}

TextSpan _smallUrl(BuildContext context, String url) {
  return TextSpan(
    text: url,
    style: TextStyle(
      fontSize: 10,
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () => launch(url),
  );
}
