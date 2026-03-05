import 'package:cat_tinder/data/local/auth_local_data_source.dart';
import 'package:cat_tinder/data/local/key_value_store.dart';
import 'package:cat_tinder/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryStore implements KeyValueStore {
  final Map<String, String> _memory = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _memory[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _memory[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _memory.remove(key);
  }
}

void main() {
  test('logged in state survives repository recreation', () async {
    final store = _InMemoryStore();

    final localDataSource1 = AuthLocalDataSource(store);
    final repository1 = AuthRepositoryImpl(localDataSource1);

    await repository1.signUp(email: 'cat@tinder.dev', password: '123456');
    expect(await repository1.isLoggedIn(), isTrue);

    final localDataSource2 = AuthLocalDataSource(store);
    final repository2 = AuthRepositoryImpl(localDataSource2);

    expect(await repository2.isLoggedIn(), isTrue);
  });
}
