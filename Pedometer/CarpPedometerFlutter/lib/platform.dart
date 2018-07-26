import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'backend.dart';

class PlatformChannel extends StatefulWidget {
  @override
  State<PlatformChannel> createState() => new StepCountChannelState();
}

class StepCountChannelState extends State<PlatformChannel> {
  String stepCountValue;
  ChannelBackEnd channelBackEnd =
      new ChannelBackEnd('samples.flutter.io/charging');

  @override
  void initState() {
    super.initState();
    channelBackEnd.initState();
    stepCountValue = channelBackEnd.stepCountValue;
  }

  void updateStepCount() {
    setState(() {
      stepCountValue = channelBackEnd.stepCountValue;
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
          new RaisedButton(
            child: const Text('Click me!'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            onPressed: updateStepCount,
          ),
        ],
      ),
    );
  }
}
