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
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.network(
                      "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${coin!.name!.toLowerCase()}.png"),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "\$ ${coin?.values?.uSD?.price?.toStringAsFixed(2)}\n", style: TextStyle(fontSize: 18)),
                      TextSpan(
                          text: "\$ ${coin?.values?.uSD?.percentChange24h}",
                        style: TextStyle(color: (coin!.values!.uSD!.percentChange24h! >= 0)? Colors.green: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9), children: [
              infoCard("Circulating Supply", "${coin!.circulatingSupply}"),
              infoCard("Total Supply", "${coin!.totalSupply}"),
              infoCard("Max Supply", "${coin!.maxSupply}"),
              infoCard("Rank", "${coin!.rank}"),
            ],),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String s, String data) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s, style: TextStyle(fontSize: 18),),
          SizedBox(height: 10,),
          Text(data),
        ],
      ),
    );
  }
}
