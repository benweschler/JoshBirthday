import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'home/coupon_row/coupon.dart';
import 'home/coupon_row/coupon_list.dart';

class Bootstrapper {
  static Future<void> bootstrapApp() async {
    InternetConnectionChecker().checkInterval =
        const Duration(milliseconds: 200);
    bool isOnline = await InternetConnectionChecker().hasConnection;

    String? appID = await _getAppID(isOnline);

    // Protect against any weird edge case errors of appID being null while
    // online.
    if (isOnline && appID != null) {
      await _syncWithFirestore(appID);
    }
  }

  /// Activates the app by giving it unique app ID if the device is online and
  /// one does not exist. Returns the app's ID, or null if it is not activated.
  static Future<String?> _getAppID(bool isOnline) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Give this instance of the app a unique ID if it doesn't already have one,
    // but force app to register with Firebase on first run. If this is the
    // first run and there is not network connection, do not activate the app by
    // giving it an ID.
    if (prefs.getString('app_id') == null && isOnline) {
      await prefs.setString('app_id', const Uuid().v1());
    }
    return prefs.getString('app_id');
  }

  static Future<void> _syncWithFirestore(String appID) async {
    // Get an instance of both the local cache and Firestore database
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
