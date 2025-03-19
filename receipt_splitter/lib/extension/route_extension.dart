import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigatorExt on BuildContext {
  /// Performs a [GoRouter.of(context).pushNamedAndRemoveUntil] action with given [routeName]
  Future<dynamic> pushNamedAndRemoveUntil(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    while (canPop()) {
      pop();
    }
    pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
