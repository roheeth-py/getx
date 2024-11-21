import 'package:get/get.dart';
import 'package:myapp/controller/asset_controller.dart';
import 'package:myapp/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(HttpService());
}

Future<void> registerController() async {
  Get.put(AssetController());
}
