import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floof/utils/network_utils.dart';
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

    print('bootstrap start.');

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
        print('bootstrap error: $_');
        return false;
      }
    }
    // Only set an app id if syncing to Firebase is successful.
    await prefs.setString('app_id', appID);

    print('bootstrap successful');

    return true;
  }

  static Future<void> _downloadPhotosFromFirebase() async {
    print("_downloadPhotosFromFirebase");
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String picturePath = "${appDocDir.path}/pictures";
    final Directory pictureDownloadDir = Directory(picturePath);

    // Only download photos if photos have not already been downloaded. When
    // photos are downloaded, the /pictures directory is created.
    if (await pictureDownloadDir.exists()) {
      print('picture dir exists.');
      return;
    }
    pictureDownloadDir.create();

    final firebaseStorage = FirebaseStorage.instance.ref().child("pictures");
    final ListResult pictureList = await firebaseStorage.listAll();
    print("Pic Num: ${pictureList.items.length}");
    int count = 1;
    for (var picture in pictureList.items) {
      print(
          'writing picture number ${count++} called ${picture.name} from firebase');
      final file = File("${pictureDownloadDir.path}/${picture.name}");
      await picture.writeToFile(file).catchError((e) async {
        await pictureDownloadDir.delete();
        throw Exception("Exception occurred during picture download");
      });
    }
    print(
        'files found in download dir after download: ${(await pictureDownloadDir.list().toList()).length}');
    print('picture download successfully completed.');
  }

  static Future<void> _syncCouponsWithFirestore(String appID) async {
    print("_syncCouponsWithFirestore");
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
