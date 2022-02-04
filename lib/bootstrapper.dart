import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'home/coupon_row/coupon.dart';
import 'home/coupon_row/coupon_list.dart';

class Bootstrapper {
  /// Ensures that only one instance of the app is able to push to Firestore at a
  /// time.
  static Future<void> checkAppID() async {
    InternetConnectionChecker().checkInterval = const Duration(milliseconds: 200);
    bool isOnline = await InternetConnectionChecker().hasConnection;

    final prefs = await SharedPreferences.getInstance();
    // Give this instance of the app a unique ID if it doesn't already have one
    if (prefs.getString('app_id') == null) {
      await prefs.setString('app_id', const Uuid().v1());
    }
    String appID = prefs.getString('app_id')!;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get the collection containing coupon data.
    CollectionReference couponsCollection = firestore.collection('coupons');
    // Get the app_id currently registered with firestore
    DocumentSnapshot appIDDoc =
        await firestore.doc('app_id/active_app_id').get();
    String activeFirestoreID = appIDDoc.get('active_app_id') as String;
    // Another app instance has written to Firestore more recently than this one
    if (activeFirestoreID != appID) {
      // Set the active app ID in Firestore to this one
      await firestore
          .doc('app_id/active_app_id')
          .update({'active_app_id': appID});

      // Pull coupon record from Firestore to local storage
      for (Coupon coupon in CouponList.coupons) {
        bool firestoreCouponValue =
            (await couponsCollection.doc('${coupon.firestoreID}').get())
                .get('isActive') as bool;
        await prefs.setBool(coupon.title, firestoreCouponValue);
      }
    }
    // This app instance has written to Firestore most recently
    else {
      // Push coupon record from local storage to Firestore
      for (Coupon coupon in CouponList.coupons) {
        couponsCollection
            .doc('${coupon.firestoreID}')
            .update({'isActive': prefs.getBool(coupon.title)});
      }
    }
  }
}
