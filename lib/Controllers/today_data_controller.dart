import 'package:get/get.dart';

class TodayDataController extends GetxController {
  // Flow: 0=Light, 1=Medium, 2=Heavy, 3=Disaster
  RxInt flow = (-1).obs;

  // Mood selected
  RxList<String> moods = <String>[].obs;

  // Symptoms selected: Map<section, Set<symptoms>>
  RxMap<String, Set<String>> symptoms = <String, Set<String>>{}.obs;

  // Vaginal Discharge selected
  RxList<String> discharge = <String>[].obs;

  // Sexual Activity
  RxString sexualActivity = ''.obs;

  // Temperature & Weight (optional)
  RxDouble temperature = 0.0.obs;
  RxDouble weight = 0.0.obs;

  // Any other fields you want to track
}