import 'package:flutter/material.dart';

class NotActivatedScreen extends StatelessWidget {
  const NotActivatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: AlertDialog(
            title: Text('Network Error'),
            content: Text('It looks like you\'re not connected to the internet.'
                ' Each new download of this app needs to be registered with the'
                ' cloud, which requires an internet connection. Try closing the'
                ' app, checking your network settings to make sure you\'re '
                'connected, and relaunching the app to get those juicy memes.'),
          ),
        ),
      ),
    );
  }
}
