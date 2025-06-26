import 'package:flutter_test/flutter_test.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SecureStorageHelper', () {
    test('can be implemented', () {
      expect(SecureStorageHelper, isNotNull);
    });
  });
}
