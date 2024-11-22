import 'dart:convert';

import 'package:get/get.dart';
import 'package:myapp/models/api_response.dart';
import 'package:myapp/models/coin_data.dart';
import 'package:myapp/models/tracked_asset.dart';
import 'package:myapp/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
    loadSharedPref();
  }

  void addTrackedAsset(String name, double amount) async {
    trackedAssets.add(TrackedAsset(name: name, amount: amount));
    List<String> data = trackedAssets.map((e)=> jsonEncode(e)).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("tracked_assets", data);
  }

  Future<void> loadSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_assets");
    if(data!=null){
      trackedAssets.value = data.map((e){
        return TrackedAsset.fromJson(jsonDecode(e));
      }).toList();
    }
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var response = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(response);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  double getPortfolioValue() {
    if (trackedAssets.isEmpty || coinData.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset asset in trackedAssets) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
