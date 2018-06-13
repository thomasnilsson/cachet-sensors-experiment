// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const EventChannel eventChannel =
      const EventChannel('samples.flutter.io/charging');

  String stepCountValue = 'unknown';

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      stepCountValue = '$event';
    });
  }

  void _onError(Object error) {
    setState(() {
      stepCountValue = 'ERROR';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Steps walked:", style: new TextStyle(fontSize: 26.0)),
          new Text(stepCountValue, style: new TextStyle(fontSize: 26.0)),
        ],
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(home: new PlatformChannel()));
}
