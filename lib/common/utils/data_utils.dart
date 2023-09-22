import 'package:delivery_app/common/const/data.dart';

class DataUtils {
  // value = json['thumbUrl']
  // value = json['imgUrl']

  static pathToUrl(String value) {
    return 'http://$ip $value';
  }
}
