import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/asset_controller.dart';
import 'package:myapp/models/api_response.dart';
import 'package:myapp/services/http_service.dart';

class AddAssetsDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService http = Get.find();
    var response = await http.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(response);
    currenciesListAPIResponse.data?.forEach(
      (coin) {
        assets.add(coin.name!);
      },
    );
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetsDialog extends StatelessWidget {
  AddAssetsDialog({super.key});

  final controller = Get.put(AddAssetsDialogController());
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(25),
            clipBehavior: Clip.hardEdge,
            child: Container(
              padding: const EdgeInsets.all(15),
              height: MediaQuery.sizeOf(context).height * 0.4,
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: _buildUI(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton(
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            value: controller.selectedAsset.value,
            borderRadius: BorderRadius.circular(25),
            items: controller.assets.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    Text(e),
                    Spacer(),
                    Image.network("https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/16/${e.toLowerCase()}.png",
                        width: 18,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.error, size: 18); // Fallback widget
                        },),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedAsset.value = value;
              }
            },
          ),
          TextField(
            onChanged: (String) {
              amount = double.parse(String);
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
          TextButton(
            onPressed: () {
              AssetController assetController = Get.find();
              assetController.addTrackedAsset(
                controller.selectedAsset.value,
                amount,
              );
              Get.back(closeOverlays: true);
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Add Asset"),
          )
        ],
      );
    }
  }
}
