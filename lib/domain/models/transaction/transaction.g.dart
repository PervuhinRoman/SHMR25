// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: (json['id'] as num).toInt(),
  accountId: (json['accountId'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    _TransactionRequest(
      accountId: (json['accountId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      amount: json['amount'] as String,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$TransactionRequestToJson(_TransactionRequest instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'comment': instance.comment,
    };

_TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    _TransactionResponse(
      id: (json['id'] as num).toInt(),
      account: AccountBrief.fromJson(json['account'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      amount: json['amount'] as String,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionResponseToJson(
  _TransactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'account': instance.account,
  'category': instance.category,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
