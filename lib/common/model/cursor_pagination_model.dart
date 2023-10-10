import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
        count: count ?? this.count, hasMore: hasMore ?? this.hasMore);
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;
  CursorPaginationError({required this.message});
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data; // 요청한 모델의 리스트

  CursorPagination({required this.meta, required this.data});

  CursorPagination copyWith({CursorPaginationMeta? meta, List<T>? data}) {
    return CursorPagination<T>(
        meta: meta ?? this.meta, data: data ?? this.data);
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

// 아래 상태는 데이터가 필요하기 때문에 CursorPagination을 extends 받아야함

// 새로 고침
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({required super.meta, required super.data});
}

// 리스트의 맨 아래로 내려서 추가 데이터 요청하는 중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({required super.meta, required super.data});
}
