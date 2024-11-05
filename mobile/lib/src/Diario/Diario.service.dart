import 'dart:convert';
import 'package:mobile/src/Diario/Entrada.dart';
import 'package:http/http.dart' as http;

class DiarioService {
  final String baseUrl = 'http://localhost:3000/entradas';

  Future<List<Entrada>> obterEntradas() async {
  final response = await http.get(Uri.parse('http://localhost:3000/entradas'));

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Entrada.fromJson(e)).toList();
  } else {
    throw Exception('Falha ao carregar entradas');
  }
}
  Future<Entrada> criarEntrada(Entrada entrada) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entrada.toJson()),
    );

    if (response.statusCode == 201) {
      return Entrada.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao criar entrada');
    }
  }
}
