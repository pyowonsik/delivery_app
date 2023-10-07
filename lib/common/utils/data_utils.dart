import 'package:delivery_app/common/const/data.dart';

class DataUtils {
  // value = json['thumbUrl']
  // value = json['imgUrl']

  static String pathToUrl(String value) {
    return 'http://$ip $value';
  }

  static List<String> listPathsToUrl(List<String> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
