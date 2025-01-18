import 'package:baustaka/api/picker_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:get/get.dart';

class PickerController extends GetxController {
  var isFetching = false.obs;

  Rx<Picker?> picker = Rx(null);

  final _pickerApi = Get.put(PickerApi());

  final String pickerId;

  PickerController({
    required this.pickerId,
  });

  @override
  void onInit() async {
    super.onInit();

    fetch();
  }

  void fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      picker.value =
          (await _pickerApi.retrieve({'pickerId': pickerId})).data?.picker;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
