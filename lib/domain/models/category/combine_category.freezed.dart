// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combine_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CombineCategory {

 Category get category; double get totalAmount; TransactionResponse? get lastTransaction;
/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombineCategoryCopyWith<CombineCategory> get copyWith => _$CombineCategoryCopyWithImpl<CombineCategory>(this as CombineCategory, _$identity);

  /// Serializes this CombineCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombineCategory&&(identical(other.category, category) || other.category == category)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.lastTransaction, lastTransaction) || other.lastTransaction == lastTransaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,totalAmount,lastTransaction);

@override
String toString() {
  return 'CombineCategory(category: $category, totalAmount: $totalAmount, lastTransaction: $lastTransaction)';
}


}

/// @nodoc
abstract mixin class $CombineCategoryCopyWith<$Res>  {
  factory $CombineCategoryCopyWith(CombineCategory value, $Res Function(CombineCategory) _then) = _$CombineCategoryCopyWithImpl;
@useResult
$Res call({
 Category category, double totalAmount, TransactionResponse? lastTransaction
});


$CategoryCopyWith<$Res> get category;$TransactionResponseCopyWith<$Res>? get lastTransaction;

}
/// @nodoc
class _$CombineCategoryCopyWithImpl<$Res>
    implements $CombineCategoryCopyWith<$Res> {
  _$CombineCategoryCopyWithImpl(this._self, this._then);

  final CombineCategory _self;
  final $Res Function(CombineCategory) _then;

/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? totalAmount = null,Object? lastTransaction = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,lastTransaction: freezed == lastTransaction ? _self.lastTransaction : lastTransaction // ignore: cast_nullable_to_non_nullable
as TransactionResponse?,
  ));
}
/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<$Res>? get lastTransaction {
    if (_self.lastTransaction == null) {
    return null;
  }

  return $TransactionResponseCopyWith<$Res>(_self.lastTransaction!, (value) {
    return _then(_self.copyWith(lastTransaction: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _CombineCategory implements CombineCategory {
  const _CombineCategory({required this.category, required this.totalAmount, this.lastTransaction});
  factory _CombineCategory.fromJson(Map<String, dynamic> json) => _$CombineCategoryFromJson(json);

@override final  Category category;
@override final  double totalAmount;
@override final  TransactionResponse? lastTransaction;

/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CombineCategoryCopyWith<_CombineCategory> get copyWith => __$CombineCategoryCopyWithImpl<_CombineCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CombineCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CombineCategory&&(identical(other.category, category) || other.category == category)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.lastTransaction, lastTransaction) || other.lastTransaction == lastTransaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,totalAmount,lastTransaction);

@override
String toString() {
  return 'CombineCategory(category: $category, totalAmount: $totalAmount, lastTransaction: $lastTransaction)';
}


}

/// @nodoc
abstract mixin class _$CombineCategoryCopyWith<$Res> implements $CombineCategoryCopyWith<$Res> {
  factory _$CombineCategoryCopyWith(_CombineCategory value, $Res Function(_CombineCategory) _then) = __$CombineCategoryCopyWithImpl;
@override @useResult
$Res call({
 Category category, double totalAmount, TransactionResponse? lastTransaction
});


@override $CategoryCopyWith<$Res> get category;@override $TransactionResponseCopyWith<$Res>? get lastTransaction;

}
/// @nodoc
class __$CombineCategoryCopyWithImpl<$Res>
    implements _$CombineCategoryCopyWith<$Res> {
  __$CombineCategoryCopyWithImpl(this._self, this._then);

  final _CombineCategory _self;
  final $Res Function(_CombineCategory) _then;

/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? totalAmount = null,Object? lastTransaction = freezed,}) {
  return _then(_CombineCategory(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,lastTransaction: freezed == lastTransaction ? _self.lastTransaction : lastTransaction // ignore: cast_nullable_to_non_nullable
as TransactionResponse?,
  ));
}

/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CombineCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<$Res>? get lastTransaction {
    if (_self.lastTransaction == null) {
    return null;
  }

  return $TransactionResponseCopyWith<$Res>(_self.lastTransaction!, (value) {
    return _then(_self.copyWith(lastTransaction: value));
  });
}
}

// dart format on
