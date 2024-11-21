import 'package:flutter/material.dart';
import 'package:myapp/models/coin_data.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  DetailsScreen({this.coin, super.key});
  CoinData? coin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coin!.name!),
      ),
    );
  }
}
