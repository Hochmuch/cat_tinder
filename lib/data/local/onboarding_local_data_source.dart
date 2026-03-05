import 'key_value_store.dart';

class OnboardingLocalDataSource {
  OnboardingLocalDataSource(this._store);

  final KeyValueStore _store;
  static const _doneKey = 'onboarding_done';

  Future<bool> isCompleted() async {
    final value = await _store.read(key: _doneKey);
    return value == '1';
  }

  Future<void> setCompleted() => _store.write(key: _doneKey, value: '1');
}
