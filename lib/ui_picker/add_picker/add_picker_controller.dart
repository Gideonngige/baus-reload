import 'package:baustaka/api/picker_api.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:get/get.dart';

class AddPickerController extends GetxController {
  var isAdding = false.obs;

  final _pickerApi = Get.put(PickerApi());

  Rx<Map<String, dynamic>> map = Rx({});

  Rx<Station?> station = Rx(null);

  add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    if (check()) {
      try {
        var picker = (await _pickerApi.create(map.value)).data?.picker;

        await Get.offAndToNamed('${Routes.kPicker}${picker?.id}');

        await Get.find<HomeWasteManagerController>(tag: 'home').fetch();
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  bool check() {
    try {
      if (map.value['mode'] == null) throw 'What vehicle are you using?';

      if (map.value['plate'] == null) {
        throw 'What is the plate number of the vehicle?';
      }

      if (station.value == null) throw 'Select transfer station of operation';

      map.value['station'] = station.value?.id;

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
