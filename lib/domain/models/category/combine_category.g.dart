// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combine_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CombineCategory _$CombineCategoryFromJson(Map<String, dynamic> json) =>
    _CombineCategory(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      lastTransaction:
          json['lastTransaction'] == null
              ? null
              : TransactionResponse.fromJson(
                json['lastTransaction'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$CombineCategoryToJson(_CombineCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
      'totalAmount': instance.totalAmount,
      'lastTransaction': instance.lastTransaction,
    };
