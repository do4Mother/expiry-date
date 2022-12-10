// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc_helper.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StateHelperCWProxy<T> {
  StateHelper<T> data(T? data);

  StateHelper<T> message(String message);

  StateHelper<T> status(Status status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StateHelper<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StateHelper<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  StateHelper<T> call({
    T? data,
    String? message,
    Status? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStateHelper.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStateHelper.copyWith.fieldName(...)`
class _$StateHelperCWProxyImpl<T> implements _$StateHelperCWProxy<T> {
  final StateHelper<T> _value;

  const _$StateHelperCWProxyImpl(this._value);

  @override
  StateHelper<T> data(T? data) => this(data: data);

  @override
  StateHelper<T> message(String message) => this(message: message);

  @override
  StateHelper<T> status(Status status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StateHelper<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StateHelper<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  StateHelper<T> call({
    Object? data = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return StateHelper<T>(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as T?,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as Status,
    );
  }
}

extension $StateHelperCopyWith<T> on StateHelper<T> {
  /// Returns a callable class that can be used as follows: `instanceOfStateHelper.copyWith(...)` or like so:`instanceOfStateHelper.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StateHelperCWProxy<T> get copyWith => _$StateHelperCWProxyImpl<T>(this);
}
