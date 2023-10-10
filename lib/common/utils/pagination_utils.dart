import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate(
      {required ScrollController controller,
      required PaginationStateNotifier provider}) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paiginate(fetchMore: true);
    }
  }
}
