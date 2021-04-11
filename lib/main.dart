import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/models/coin.dart';
import 'package:flutter_assessment/widgets/coin_list.dart';

const kCoinReal = 'Real';
const kCoinFake = 'Fake';

void main() {
  runApp(AutomaticCoinDetectorApp());
}

/// The main widget of the app
class AutomaticCoinDetectorApp extends StatelessWidget {
  final Stream<String> _coinStream = Stream.periodic(
    Duration(seconds: 2),
    (count) => count % 2 == 0 ? kCoinReal : kCoinFake,
  ).asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _coinStream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: snapshot.hasData ? snapshot.data! : 'Automated Coin Detector',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MainPage(coinStream: _coinStream),
          );
        });
  }
}

/// THe main page of the app
class MainPage extends StatefulWidget {
  /// Coin stream that will be used to display the list
  final Stream coinStream;

  MainPage({Key? key, required this.coinStream}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Coin> _coins = List.empty(growable: true);
  String? _lastCoin;
  GlobalKey<CoinListState> _listKey = GlobalKey();

  @override
  void initState() {
    widget.coinStream.listen((coin) {
      setState(() {
        _coins.add(Coin(coin));
        _listKey.currentState?.addCoin(_coins.length - 1);
        _lastCoin = coin;
        if (coin == kCoinReal) _playSoundFile();
      });
    });
    super.initState();
  }

  _playSoundFile() {
    AudioCache cache = new AudioCache();
    cache.play('coin10.wav');
  }

  @override
  Widget build(BuildContext context) {
    var lastCoin = _lastCoin;
    return Scaffold(
      appBar: AppBar(
        title: Text('Last: ${lastCoin != null ? _lastCoin : 'No coin'}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                var count = _coins.length;
                _coins.clear();
                _listKey.currentState?.clear(count);
                _lastCoin = null;
              });
            },
          ),
        ],
      ),
      body: CoinList(
        key: _listKey,
        itemLookup: (i) => _coins[i],
        onExpand: (coin) {
          if (coin.coin == kCoinReal) _playSoundFile();
        },
        numItems: _coins.length,
      ),
    );
  }
}
