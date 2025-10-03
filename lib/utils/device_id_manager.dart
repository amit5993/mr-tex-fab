import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

class DeviceIdManager {
  static const String _storedDeviceIdKey = 'persistent_device_id';

  /// Gets a persistent device ID that survives app reinstallations
  static Future<String> getPersistentDeviceId() async {
    // First check if we already have a stored persistent ID
    final prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(_storedDeviceIdKey);

    // If we have a stored ID, use it
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }

    // Otherwise, generate a new persistent ID
    String deviceId = await _generateDeviceId();

    // Store it for future use
    await prefs.setString(_storedDeviceIdKey, deviceId);

    return deviceId;
  }

  /// Generates a device ID using the best available method
  static Future<String> _generateDeviceId() async {
    String deviceId = '';

    // Try to get hardware-based identifiers first
    try {
      // Try UniqueIdentifier first
      try {
        final serial = await UniqueIdentifier.serial;
        if (serial != null && serial.isNotEmpty) {
          return serial;
        }
      } catch (e) {
        // Continue to next method
      }

      // Use device_info_plus as fallback
      final deviceInfoPlugin = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;

        // Combine multiple identifiers for better persistence
        List<String> identifiers = [];

        // Android ID - can change on factory reset but generally persistent
        if (androidInfo.id.isNotEmpty) {
          identifiers.add(androidInfo.id);
        }

        // Add more persistent identifiers
        if (androidInfo.serialNumber != null && androidInfo.serialNumber!.isNotEmpty && androidInfo.serialNumber != 'unknown') {
          identifiers.add(androidInfo.serialNumber!);
        }

        if (androidInfo.fingerprint.isNotEmpty) {
          identifiers.add(androidInfo.fingerprint);
        }

        // Add device model info for more uniqueness
        if (androidInfo.model.isNotEmpty) {
          identifiers.add(androidInfo.model);
        }

        if (androidInfo.brand.isNotEmpty) {
          identifiers.add(androidInfo.brand);
        }

        deviceId = identifiers.join('_');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;

        List<String> identifiers = [];

        // Use identifierForVendor but know it can change
        if (iosInfo.identifierForVendor != null && iosInfo.identifierForVendor!.isNotEmpty) {
          identifiers.add(iosInfo.identifierForVendor!);
        }

        // Add device model info for more uniqueness
        if (iosInfo.model.isNotEmpty) {
          identifiers.add(iosInfo.model);
        }

        if (iosInfo.systemName.isNotEmpty) {
          identifiers.add(iosInfo.systemName);
        }

        if (iosInfo.name.isNotEmpty) {
          identifiers.add(iosInfo.name);
        }

        deviceId = identifiers.join('_');
      }
    } catch (e) {
      // If all else fails, generate a simple timestamp-based ID
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // If we couldn't get any hardware ID, use timestamp
    if (deviceId.isEmpty) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
    }

    return deviceId;
  }
}