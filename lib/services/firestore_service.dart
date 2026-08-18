import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static num _toNum(dynamic value) {
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
    return 0;
  }

  static num _readScalar(Map<String, dynamic> data, List<String> keys) {
    final lowered = data.map((k, v) => MapEntry(k.toString().toLowerCase(), v));

    for (final key in keys) {
      final value = lowered[key.toLowerCase()];
      if (value != null) return _toNum(value);
    }

    for (final nestedKey in ['values', 'reading', 'sensor', 'data']) {
      final nested = lowered[nestedKey.toLowerCase()];
      if (nested is Map) {
        return _readScalar(Map<String, dynamic>.from(nested), keys);
      }
    }

    return 0;
  }

  static Map<String, dynamic> normalizeSensorData(
    String id,
    Map<String, dynamic>? rawData,
  ) {
    final data = rawData ?? const <String, dynamic>{};

    final temperature = _readScalar(data, [
      'temperature',
      'temp',
      'currentTemperature',
      'temperatureC',
      'tempC',
    ]);
    final humidity = _readScalar(data, [
      'humidity',
      'rh',
      'relativeHumidity',
      'moisture',
      'humidityPercent',
    ]);
    final gasValue = _readScalar(data, [
      'gasValue',
      'gas',
      'gasSensor',
      'mq135',
      'mq135Value',
      'gas_value',
    ]);
    final rawAqi = _readScalar(data, [
      'aqi',
      'AQI',
      'aqiValue',
      'airQualityIndex',
      'airQuality',
      'qualityIndex',
      'air_quality_index',
    ]);

    // Calculate AQI from MQ-135 Gas Value if explicit AQI field is not present
    num computedAqi = rawAqi;
    if (computedAqi == 0 && gasValue > 0) {
      if (gasValue > 500) {
        // MQ-135 raw 12-bit ADC value scale (0-4095) mapped to 0-500 AQI scale
        computedAqi = ((gasValue / 4095.0) * 500.0).clamp(10.0, 500.0);
      } else {
        computedAqi = gasValue;
      }
    }

    return {
      'id': id,
      'name': data['name'] ?? 'AirGuard ESP32',
      'temperature': temperature,
      'humidity': humidity,
      'gasValue': gasValue,
      'aqi': double.parse(computedAqi.toStringAsFixed(1)),
      'location': data['location'] ?? 'ESP32 Air Station',
      'online': data['online'] ?? true,
      'timestamp':
          data['timestamp'] ?? DateTime.now().toUtc().toIso8601String(),
    };
  }

  Stream<Map<String, dynamic>?> primaryDeviceStream() {
    return _firestore.collection('sensorData').doc('latest').snapshots().map((
      snapshot,
    ) {
      debugPrint('================================');
      debugPrint('FIRESTORE SNAPSHOT RECEIVED [sensorData/latest]');
      debugPrint('Exists: ${snapshot.exists}');
      debugPrint('Data: ${snapshot.data()}');
      debugPrint('================================');

      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return normalizeSensorData('latest', snapshot.data());
    });
  }

  Stream<List<Map<String, dynamic>>> readingsStream(String id) {
    return _firestore.collection('sensorData').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];

      final readings = snapshot.docs
          .map((doc) => normalizeSensorData(doc.id, doc.data()))
          .toList();

      return readings;
    });
  }

  Stream<List<Map<String, dynamic>>> devicesStream() {
    return _firestore.collection('sensorData').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs
          .map((doc) => normalizeSensorData(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> alertsStream() {
    return primaryDeviceStream().map((deviceData) {
      final List<Map<String, dynamic>> generatedAlerts = [];

      if (deviceData == null) return generatedAlerts;

      final aqi = (deviceData['aqi'] as num?)?.toDouble() ?? 0.0;
      final gasValue = (deviceData['gasValue'] as num?)?.toDouble() ?? 0.0;
      final humidity = (deviceData['humidity'] as num?)?.toDouble() ?? 0.0;

      // 1. High Gas Concentration Alert
      if (gasValue > 1000) {
        generatedAlerts.add({
          'id': 'alert_gas_1000',
          'title': 'High Gas Concentration Detected',
          'message':
              'MQ-135 Gas Sensor reading reached ${gasValue.toStringAsFixed(0)} ADC. Please ensure proper ventilation.',
          'severity': 'hazardous',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }

      // 2. Air Quality Index Threshold Alert
      if (aqi > 100) {
        generatedAlerts.add({
          'id': 'alert_aqi_100',
          'title': 'Air Quality Warning (AQI ${aqi.toStringAsFixed(0)})',
          'message':
              'Air quality is Unhealthy for Sensitive Groups. Sensitive individuals should consider wearing a mask.',
          'severity': aqi > 150 ? 'high' : 'medium',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }

      // 3. Humidity Alert
      if (humidity > 80) {
        generatedAlerts.add({
          'id': 'alert_hum_80',
          'title': 'Elevated Moisture & Humidity',
          'message':
              'Relative humidity is at ${humidity.toStringAsFixed(1)}%. High humidity can trap airborne pollutants.',
          'severity': 'info',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }

      return generatedAlerts;
    });
  }

  Future<void> markAlertRead(String alertId) async {}
}

