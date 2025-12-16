import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ioc/ioc/ioc.dart';

class ApiClient {
  ApiClient(this.baseUrl);
  final String baseUrl;
}

class Repository {
  Repository(this.client);
  final ApiClient client;
}

class Service {
  Service(this.repository);
  final Repository repository;
}

class MockRepository extends Repository {
  MockRepository(ApiClient client) : super(client);
}

class NeedsProperty {
  late String injectedValue;
}

class Logger {
  Logger(this.label);
  final String label;
}

class FirstCircular {
  FirstCircular(ContainerResolver resolver) {
    resolver.resolve<SecondCircular>();
  }
}

class SecondCircular {
  SecondCircular(ContainerResolver resolver) {
    resolver.resolve<FirstCircular>();
  }
}

class AsyncService {
  AsyncService(this.message);
  final String message;
}

class DemoModule implements AutoRegistrar {
  @override
  void register(IoCContainer container) {
    container.registerSingleton<ApiClient>((resolver) => ApiClient(resolver.env('baseUrl') as String? ?? 'https://example'));
  }
}

void main() {
  group('IoC container', () {
    test('supports singleton and transient lifetimes', () {
      final container = Container();
      container.registerSingleton<Logger>((_) => Logger('singleton'));
      container.registerTransient<Logger>((_) => Logger('transient'), name: 'transient');

      final a = container.resolve<Logger>();
      final b = container.resolve<Logger>();
      final c = container.resolve<Logger>(name: 'transient');
      final d = container.resolve<Logger>(name: 'transient');

      expect(identical(a, b), isTrue);
      expect(identical(c, d), isFalse);
      expect(a.label, 'singleton');
      expect(c.label, 'transient');
    });

    test('performs constructor injection through factories', () {
      final container = Container(environment: {'baseUrl': 'https://api.local'});
      container.registerSingleton<ApiClient>((resolver) => ApiClient(resolver.env('baseUrl') as String));
      container.registerTransient<Repository>((resolver) => Repository(resolver.resolve<ApiClient>()));
      container.registerTransient<Service>((resolver) => Service(resolver.resolve<Repository>()));

      final service = container.resolve<Service>();
      expect(service.repository.client.baseUrl, 'https://api.local');
    });

    test('detects circular dependencies', () {
      final container = Container();
      container.registerTransient<FirstCircular>((resolver) => FirstCircular(resolver));
      container.registerTransient<SecondCircular>((resolver) => SecondCircular(resolver));

      expect(() => container.resolve<FirstCircular>(), throwsA(isA<ContainerException>()));
    });

    test('supports named and conditional registrations', () {
      final container = Container(environment: {'useMock': true});
      container.registerSingleton<Repository>(
        (resolver) => MockRepository(ApiClient('mock')),
        condition: (resolver) => resolver.flag('useMock'),
      );
      container.registerSingleton<Repository>(
        (resolver) => Repository(ApiClient('prod')),
        condition: (resolver) => !resolver.flag('useMock'),
      );

      final repo = container.resolve<Repository>();
      expect(repo, isA<MockRepository>());
      expect(repo.client.baseUrl, 'mock');
    });

    test('uses scoped lifetime inside child containers', () {
      final root = Container();
      root.registerScoped<Logger>((_) => Logger('scoped'));

      final scopeA = root.createScope();
      final scopeB = root.createScope();
      final loggerA1 = scopeA.resolve<Logger>();
      final loggerA2 = scopeA.resolve<Logger>();
      final loggerB = scopeB.resolve<Logger>();

      expect(identical(loggerA1, loggerA2), isTrue);
      expect(identical(loggerA1, loggerB), isFalse);
    });

    test('injects properties after construction', () {
      final container = Container();
      container.registerTransient<NeedsProperty>(
        (_) => NeedsProperty(),
        propertyInjectors: [
          (instance, resolver) {
            instance.injectedValue = resolver.resolve<Logger>().label;
          }
        ],
      );
      container.registerSingleton<Logger>((_) => Logger('property'));

      final instance = container.resolve<NeedsProperty>();
      expect(instance.injectedValue, 'property');
    });

    test('resolves async factories', () async {
      final container = Container();
      container.registerSingleton<AsyncService>(
        (_) async => AsyncService('ready'),
      );

      final service = await container.resolveAsync<AsyncService>();
      expect(service.message, 'ready');
      expect(() => container.resolve<AsyncService>(), throwsA(isA<ContainerException>()));
    });

    test('auto registers via modules', () {
      final container = Container(environment: {'baseUrl': 'https://module'});
      container.autoRegister([DemoModule()]);

      final client = container.resolve<ApiClient>();
      expect(client.baseUrl, 'https://module');
    });
  });
}
