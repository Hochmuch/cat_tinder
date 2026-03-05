import 'package:flutter_test/flutter_test.dart';
import 'package:cat_tinder/domain/usecases/validators.dart';

void main() {
  test('password validator', () {
    expect(validatePassword('123'), isNotNull);
    expect(validatePassword('123456'), isNull);
  });
}
