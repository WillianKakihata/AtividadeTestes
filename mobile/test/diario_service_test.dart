import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/src/Diario/Diario.service.dart';
import 'package:mobile/src/Diario/Entrada.dart';
import 'dart:convert';

import 'diario_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('DiarioService Test', () {
    final mockClient = MockClient();

    test('obterEntradas retorna uma lista de entradas', () async {
      final diarioService = DiarioService(client: mockClient);

      when(mockClient.get(Uri.parse('http://localhost:3000/entradas')))
          .thenAnswer((_) async => http.Response(
              '[{"id": 1, "data": "2024-11-05", "titulo": "Meu primeiro dia de diário", "conteudo": "Hoje foi um dia tranquilo."}]', 200));

      final entradas = await diarioService.obterEntradas();

      expect(entradas, isA<List<Entrada>>());
      expect(entradas.length, 1); 
      expect(entradas[0].titulo, 'Meu primeiro dia de diário');
    });

    test('obterEntradas lança exceção quando falha', () async {
      final diarioService = DiarioService(client: mockClient);

      when(mockClient.get(Uri.parse('http://localhost:3000/entradas')))
          .thenAnswer((_) async => http.Response('Not Found', 404));


      await expectLater(diarioService.obterEntradas(), throwsA(isA<Exception>()));
    });
  });
}
