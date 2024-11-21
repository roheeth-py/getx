import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/asset_controller.dart';
import 'package:myapp/features/main_screen/details_screen.dart';
import 'package:myapp/widgets/main_screen/add_assets_dialog.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  AssetController assetController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              portfolioValue(context),
              trackedAsset(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
      ),
      // backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(AddAssetsDialog());
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget portfolioValue(BuildContext context) {
    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            const TextSpan(
              text: "\$ ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text:
                  "${assetController.getPortfolioValue().toStringAsFixed(2)}\n",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const TextSpan(
              text: "Portfolio Value",
            ),
          ],
        ),
      ),
    );
  }

  Widget trackedAsset(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: const Text("Portfolio"),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: ListView.builder(
              itemCount: assetController.trackedAssets.length,
              itemBuilder: (context, index) {
                final coin = assetController.trackedAssets[index];
                final data = assetController.coinData
                    .firstWhere((e) => e.name == coin.name);
                return ListTile(
                  leading: Image.network(
                      "https://github.com/ErikThiart/cryptocurrency-icons/blob/master/128/ethereum.png"),
                  title: Text(assetController.trackedAssets[index].name!),
                  subtitle: Text(
                    "USD: ${assetController.getAssetPrice(data.name!) * assetController.trackedAssets[index].amount!.toDouble()}",
                  ),
                  trailing:
                      Text("${assetController.trackedAssets[index].amount}"),
                  onTap: () => Get.to(DetailsScreen(coin: assetController.getCoinData(data.name!))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
