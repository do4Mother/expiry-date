import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

part 'bloc_helper.g.dart';

@CopyWith()
class StateHelper<T> extends Equatable {
  final Status status;
  final T? data;
  final String message;

  const StateHelper({this.status = Status.initial, this.data, this.message = ''});

  @override
  List<Object?> get props => [status, data, message];

  builder({Widget? loading, required Widget loaded, Widget? error}) {
    if (status == Status.loading) {
      return loading ??
          const Center(
            child: CircularProgressIndicator.adaptive(),
          );
    }
    if (status == Status.loaded) {
      return loaded;
    }
    if (status == Status.error) {
      return error ?? const SizedBox();
    }
    return const SizedBox();
  }

  listener({Function? loading, Function? loaded, Function? error}) {
    if (status == Status.loading && loading != null) {
      loading();
    }
    if (status == Status.loaded && loaded != null) {
      loaded();
    }
    if (status == Status.error && error != null) {
      error();
    }
  }
}

enum Status { initial, loading, loaded, error }
