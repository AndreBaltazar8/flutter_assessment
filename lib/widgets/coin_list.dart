import 'package:flutter/material.dart';
import 'package:flutter_assessment/models/coin.dart';

/// An animated list of coins
class CoinList extends StatefulWidget {
  final Coin Function(int) itemLookup;
  final void Function(Coin) onExpand;
  final int numItems;

  CoinList({
    Key? key,
    required this.itemLookup,
    required this.onExpand,
    required this.numItems,
  }) : super(key: key);

  @override
  CoinListState createState() => CoinListState();
}

class CoinListState extends State<CoinList> {
  GlobalKey<AnimatedListState> _animatedListState = GlobalKey();

  /// Notifies the animated list about the new coin
  void addCoin(int index) {
    _animatedListState.currentState?.insertItem(index);
  }

  /// Clears all coins from the list
  void clear(int numItems) {
    for (var i = 0; i < numItems; i++) {
      _animatedListState.currentState?.removeItem(0, (context, animation) => Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedList(
        key: _animatedListState,
        itemBuilder: (_, i, animation) => _buildCoinItem(widget.itemLookup(i), animation),
        initialItemCount: widget.numItems,
        reverse: true,
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildCoinItem(Coin coin, Animation<double> animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: Container(
            color: Colors.green.withAlpha(100),
            child: ExpansionTile(
              title: Text(coin.coin),
              children: [
                Container(
                  child: Text(coin.time.toIso8601String()),
                ),
              ],
              onExpansionChanged: (expanding) {
                if (expanding) widget.onExpand(coin);
              },
            ),
          ),
        ),
      );
}
