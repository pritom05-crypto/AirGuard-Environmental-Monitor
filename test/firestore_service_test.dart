import 'package:airguard_new/services/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreService normalization', () {
    test(
      'uses real Firestore fields for temperature, humidity, gas and aqi',
      () {
        final data = {
          'temperature': 27.4,
          'humidity': 58,
          'gasValue': 432,
          'aqi': 76,
        };

        final normalized = FirestoreService.normalizeSensorData('latest', data);

        expect(normalized['id'], 'latest');
        expect(normalized['temperature'], 27.4);
        expect(normalized['humidity'], 58);
        expect(normalized['gasValue'], 432);
        expect(normalized['aqi'], 76);
      },
    );

    test(
      'falls back to alternate field names when document uses different keys',
      () {
        final data = {
          'temp': 22.8,
          'rh': 44,
          'mq135': 510,
          'airQualityIndex': 82,
        };

        final normalized = FirestoreService.normalizeSensorData('latest', data);

        expect(normalized['temperature'], 22.8);
        expect(normalized['humidity'], 44);
        expect(normalized['gasValue'], 510);
        expect(normalized['aqi'], 82);
      },
    );
  });
}
