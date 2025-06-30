import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr_finance/domain/models/category/category.dart';

import '../transaction/transaction.dart';

part 'combine_category.freezed.dart';
part 'combine_category.g.dart';

@freezed
abstract class CombineCategory with _$CombineCategory {
  const factory CombineCategory({
    required Category category,
    required double totalAmount,
    TransactionResponse? lastTransaction,
  }) = _CombineCategory;

  factory CombineCategory.fromJson(Map<String, dynamic> json) => _$CombineCategoryFromJson(json);
}