import 'dart:html' as dom;
import 'package:test/test.dart';
import 'package:webstorage/webstorage.dart';

/// Tests the features of the [WebStorage] class.
void main() => group('WebStorage', () {
  final sessionStorage = dom.window.sessionStorage;
  setUp(sessionStorage.clear);

  group('.keys', () {
    test('should return an empty list for an empty storage', () {
      expect(SessionStorage().keys, isEmpty);
    });

    test('should return the list of keys for a non-empty storage', () {
      sessionStorage['foo'] = 'bar';
      sessionStorage['bar'] = 'baz';
      expect(SessionStorage().keys, orderedEquals(['foo', 'bar']));
    });
  });

  group('.length', () {
    test('should return zero for an empty storage', () {
      expect(SessionStorage(), isEmpty);
    });

    test('should return the number of entries for a non-empty storage', () {
      sessionStorage['foo'] = 'bar';
      sessionStorage['bar'] = 'baz';
      expect(SessionStorage(), hasLength(2));
    });
  });

  /* TODO
  group('.onChanges', () {
    test('should trigger an event when a value is added', () {
      final listener = (event: Event): void => {
      final changes = (event as CustomEvent<Map<string, SimpleChange>>).detail;
      expect([...changes.entries()], hasLength(1);
      expect([...changes.keys()][0], 'foo');

      final [record] = [...changes.values()];
      expect(record.currentValue, 'bar');
      expect(record.previousValue, isNull);

      done();
      };

      final storage = SessionStorage();
      storage.addEventListener(WebStorage.eventChanges, listener);
      storage.set('foo', 'bar');
      storage.removeEventListener(WebStorage.eventChanges, listener);
    });

    test('should trigger an event when a value is updated', () {
      sessionStorage['foo'] = 'bar';

      final listener = (event: Event): void => {
      final changes = (event as CustomEvent<Map<string, SimpleChange>>).detail;
      expect([...changes.entries()], hasLength(1);
      expect([...changes.keys()][0], 'foo');

      final [record] = [...changes.values()];
      expect(record.currentValue, 'baz');
      expect(record.previousValue, 'bar');

      done();
      };

      final storage = SessionStorage();
      storage.addEventListener(WebStorage.eventChanges, listener);

      storage.set('foo', 'baz');
      storage.removeEventListener(WebStorage.eventChanges, listener);
    });

    test('should trigger an event when a value is removed', () {
      sessionStorage['foo'] = 'bar';

      final listener = (event: Event): void => {
      final changes = (event as CustomEvent<Map<string, SimpleChange>>).detail;
      expect([...changes.entries()], hasLength(1);
      expect([...changes.keys()][0], 'foo');

      final [record] = [...changes.values()];
      expect(record.currentValue, isNull);
      expect(record.previousValue, 'bar');

      done();
      };

      final storage = SessionStorage();
      storage.addEventListener(WebStorage.eventChanges, listener);
      storage.remove('foo');
      storage.removeEventListener(WebStorage.eventChanges, listener);
    });

    test('should trigger an event when the storage is cleared', () {
      sessionStorage['foo'] = 'bar';
      sessionStorage['bar'] = 'baz';

      final listener = (event: Event): void => {
      final changes = (event as CustomEvent<Map<string, SimpleChange>>).detail;
      expect([...changes.entries()], hasLength(2);
      expect([...changes.keys()], orderedEquals(['foo', 'bar']);

      final [record1, record2] = [...changes.values()];
      expect(record1.currentValue, isNull);
      expect(record1.previousValue, 'bar');
      expect(record2.currentValue, isNull);
      expect(record2.previousValue, 'baz');

      done();
      };

      final storage = SessionStorage();
      storage.addEventListener(WebStorage.eventChanges, listener);
      storage.clear();
      storage.removeEventListener(WebStorage.eventChanges, listener);
    });
  });*/

  group('.clear()', () {
    test('should remove all storage entries', () {
      sessionStorage['foo'] = 'bar';
      sessionStorage['bar'] = 'baz';

      final storage = SessionStorage();
      expect(storage, hasLength(2));

      storage.clear();
      expect(storage, isEmpty);
    });
  });

  group('.containsKey()', () {
    test('should return `false` if the specified key is not contained', () {
      expect(SessionStorage().containsKey('foo'), isFalse);
    });

    test('should return `true` if the specified key is contained', () {
      final storage = SessionStorage();
      sessionStorage['foo'] = 'bar';
      expect(storage.containsKey('foo'), isTrue);
      expect(storage.containsKey('bar'), isFalse);
    });
  });

  group('.get()', () {
    test('should properly get the storage entries', () {
      final storage = SessionStorage();
      expect(storage.get('foo'), isNull);
      expect(storage.get('foo', '123'), '123');

      sessionStorage['foo'] = 'bar';
      expect(storage.get('foo'), 'bar');

      sessionStorage['foo'] = '123';
      expect(storage.get('foo'), '123');
    });

    test('should return the given default value if the key is not found', () {
      // TODO defaultValue
    });
  });

  group('.getObject()', () {
    test('should properly get the deserialized storage entries', () {
      final storage = SessionStorage();
      expect(storage.getObject('foo'), isNull);
      // TODO expect(storage.getObject('foo', {'key': 'value'})).to.be.an('object').that.deep.equal({key: 'value'});

      sessionStorage['foo'] = '123';
      expect(storage.getObject('foo'), 123);

      sessionStorage['foo'] = '"bar"';
      expect(storage.getObject('foo'), 'bar');

      sessionStorage['foo'] = '{"key": "value"}';
      // TODO expect(storage.getObject('foo')).to.be.an('object').that.deep.equal({'key': 'value'});
    });

    test('should return the default value if the value can\'t be deserialized', () {
      sessionStorage['foo'] = 'bar';
      expect(SessionStorage().getObject('foo', 'defaultValue'), 'defaultValue');
    });
  });

  group('.remove()', () {
    test('should properly remove the storage entries', () {
      final storage = SessionStorage();
      sessionStorage['foo'] = 'bar';
      sessionStorage['bar'] = 'baz';
      expect(sessionStorage['foo'], 'bar');

      storage.remove('foo');
      expect(sessionStorage['foo'], isNull);
      expect(sessionStorage['bar'], 'baz');

      storage.remove('bar');
      expect(sessionStorage['bar'], isNull);
    });
  });

  group('.set()', () {
    test('should properly set the storage entries', () {
      final storage = SessionStorage();
      expect(sessionStorage['foo'], isNull);
      storage.set('foo', 'bar');
      expect(sessionStorage['foo'], 'bar');
      storage.set('foo', '123');
      expect(sessionStorage['foo'], '123');
    });
  });

  group('.setObject()', () {
    test('should properly serialize and set the storage entries', () {
      final storage = SessionStorage();
      expect(sessionStorage['foo'], isNull);
      storage.setObject('foo', 123);
      expect(sessionStorage['foo'], '123');
      storage.setObject('foo', 'bar');
      expect(sessionStorage['foo'], '"bar"');
      storage.setObject('foo', {'key': 'value'});
      expect(sessionStorage['foo'], '{"key":"value"}');
    });
  });

  group('.toJson()', () {
    test('should return an empty map for an empty storage', () {
      final storage = SessionStorage();
      // TODO expect(storage.toJson()).to.be.an('object').that.is.empty;
    });

    test('should return a non-empty map for a non-empty storage', () {
      final storage = SessionStorage()..set('foo', 'bar')..set('baz', 'qux');
      // TODO expect(storage.toJson()).to.be.an('object').that.deep.equal({baz: 'qux', foo: 'bar'});
    });
  });
});
