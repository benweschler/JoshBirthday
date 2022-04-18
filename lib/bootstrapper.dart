import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floof/utils/network_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'home/coupon_row/coupon.dart';
import 'home/coupon_row/coupon_list.dart';

class Bootstrapper {
  /// If the device is connected to the internet, activates this instance of the
  /// app by syncing coupons with firestore, providing this instance of the app
  /// with an app id, and downloading the picture gallery if it hasn't already.
  /// Returns true if activation was successful, and false otherwise.
  static Future<bool> bootstrapApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnline = await isConnectedToInternet();

    String appID = prefs.getString('app_id') ?? const Uuid().v1();

    debugPrint('BOOTSTRAP START');

    if (isOnline) {
      try {
        await _syncCouponsWithFirestore(appID)
            // This may not actually be necessary, but if the device's network
            // connection is not actually connected to the internet this should be
            // an easy way of catching it, instead of hoping the firebase requests
            // throw some error.
            .timeout(const Duration(seconds: 15));
        await _downloadPhotosFromFirebase();
      } catch (_) {
        debugPrint('Bootstrap Error Caught: $_');
        return false;
      }
    }
    // Only set an app id if syncing to Firebase is successful.
    await prefs.setString('app_id', appID);

    debugPrint('Bootstrap Successful');

    return true;
  }

  static Future<void> _downloadPhotosFromFirebase() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String picturePath = "${appDocDir.path}/pictures";
    final Directory pictureDownloadDir = Directory(picturePath);

    // Only download photos if photos have not already been downloaded. When
    // photos are downloaded, the /pictures directory is created.
    if (await pictureDownloadDir.exists()) return;

    pictureDownloadDir.create();

    final firebaseStorage = FirebaseStorage.instance.ref().child("pictures");
    final ListResult pictureList = await firebaseStorage.listAll();
    debugPrint(
        "Number of pictures found in Firebase Storage: ${pictureList.items.length}");

    for (var picture in pictureList.items) {
      debugPrint('Saving ${picture.name} from firebase');
      final file = File("${pictureDownloadDir.path}/${picture.name}");
      await picture.writeToFile(file).catchError((e) async {
        await pictureDownloadDir.delete();
        throw Exception("Exception occurred during picture download");
      });
    }
    debugPrint(
        'Number of files successfully saved: ${(await pictureDownloadDir.list().toList()).length}');
    debugPrint('Picture download successfully completed.');
  }

  static Future<void> _syncCouponsWithFirestore(String appID) async {
    debugPrint("Syncing coupons with Firestore...");

    // Get an instance of both the local cache and Firestore database
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the collection containing coupon data.
    DocumentReference couponsDoc =
        firestore.collection('coupons').doc('coupons');
    // Get the app_id currently registered with firestore
    DocumentSnapshot appIDDoc =
        await firestore.doc('app_id/active_app_id').get();
    String activeFirestoreID = appIDDoc.get('active_app_id') as String;

    // Another app instance has written to Firestore more recently than this one
    if (activeFirestoreID != appID) {
      debugPrint("Pulling coupon data from Firestore...");

      // Set the active app ID in Firestore to this one
      await firestore
          .doc('app_id/active_app_id')
          .update({'active_app_id': appID});

      // Pull coupon record from Firestore to local storage
      for (Coupon coupon in CouponList.coupons) {
        bool firestoreCouponValue =
            (await couponsDoc.get()).get("${coupon.firestoreID}");
        await prefs.setBool(coupon.title, firestoreCouponValue);
      }
    }
    // This app instance has written to Firestore most recently
    else {
      debugPrint("Pushing coupon data to Firestore...");

      // Push coupon record from local storage to Firestore
      for (Coupon coupon in CouponList.coupons) {
        couponsDoc
            .update({"${coupon.firestoreID}": prefs.getBool(coupon.title)});
      }
    }
  }
}
