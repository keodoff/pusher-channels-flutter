import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> testPusher() async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    await pusher.init(
      apiKey: '',
      cluster: '',
      wsPath: '/ws',
      host: host,
      logToConsole: true,
      wsPort: 6001,
      wssPort: 443,
      enabledTransports: ['ws', 'wss'],
      useTLS: true,
      onConnectionStateChange: (currentState, previousState) {
        log(
          'onConnectionStateChange: currentState:$currentState, previousState: $previousState',
        );
      },
      onError: (message, code, error) {
        log('onError: message: $message, code: $code, error: $error');
      },
      onSubscriptionSucceeded: (channelName, data) {
        log('mesonSubscriptionSucceeded: $channelName,$data');
      },
      onEvent: (event) async {
        log(
          "Pusher Event: ${event.eventName} on channel ${event.channelName}, ${event.data}",
        );
      },
      onSubscriptionError: (message, error) {
        log('error: ${error}');
      },
      onDecryptionFailure: (event, reason) {},
      onMemberAdded: (channelName, member) {},
      onMemberRemoved: (channelName, member) {},
      onAuthorizer: (channelName, socketId, options) {
        log(
          'onAuthorizer: $channelName,socketId: $socketId,options: $options ',
        );
      },
    );
    await pusher.subscribe(channelName: 'private-call_ats.1');
    await pusher.subscribe(channelName: 'private-pong.1');

    await pusher.connect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await testPusher();
          },
          child: Text('Test'),
        ),
      )),
    );
  }
}
