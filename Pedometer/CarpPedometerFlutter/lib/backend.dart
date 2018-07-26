import 'package:flutter/services.dart';

class ChannelBackEnd {

  EventChannel _eventChannel;
  String _stepCountValue = 'not set yet';

  get stepCountValue => _stepCountValue;

  ChannelBackEnd(String channelAddress) {
    this._eventChannel = EventChannel(channelAddress);
  }

  void initState() {
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    _stepCountValue = '$event';
    print('$event');
  }

  void _onError(Object error) {
    _stepCountValue = 'ERROR';
  }
}