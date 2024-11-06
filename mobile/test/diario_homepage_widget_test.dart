import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/Diario/Diario.service.dart';
import 'package:mobile/src/Diario/Entrada.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mobile/main.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DiarioHomePage mostra entradas e botão de adicionar', (WidgetTester tester) async {
    final mockHttpClient = MockClient();
    final diarioService = DiarioService(client: mockHttpClient);

    when(mockHttpClient.get(Uri.parse('http://localhost:3000/entradas')))
        .thenAnswer((_) async => http.Response(
              '[{"id": 1, "data": "2024-11-05", "titulo": "Entrada A", "conteudo": "Conteúdo A"},'
              '{"id": 2, "data": "2024-11-05", "titulo": "Entrada B", "conteudo": "Conteúdo B"}]',
              200,
            ));

    await tester.pumpWidget(
      MaterialApp(
        home: DiarioHomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Entrada A'), findsOneWidget);
    expect(find.text('Entrada B'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
