import 'package:contact_x/core/constants/method_channel_contant.dart';
import 'package:flutter/services.dart';


class ContactPlatformService {
  static const MethodChannel _channel =
      MethodChannel(MethodChannelConstants.contactChannel);

  Future<bool> checkPermission() async {
    final result = await _channel.invokeMethod<bool>(
      MethodChannelConstants.checkPermission,
    );

    return result ?? false;
  }

  Future<bool> requestPermission() async {
    final result = await _channel.invokeMethod<bool>(
      MethodChannelConstants.requestPermission,
    );

    return result ?? false;
  }

  Future<List<Map<String, dynamic>>> fetchContacts() async {
    final result = await _channel.invokeMethod<List<dynamic>>(
      MethodChannelConstants.fetchContacts,
    );

    if (result == null) return [];

    return result
        .map(
          (e) => Map<String, dynamic>.from(e as Map),
        )
        .toList();
  }
}