import 'package:flutter/material.dart';
import 'package:mobile/src/Diario/Diario.service.dart';
import 'package:mobile/src/Diario/Entrada.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiarioHomePage(),
    );
  }
}

class DiarioHomePage extends StatefulWidget {
  const DiarioHomePage({Key? key}) : super(key: key);

  @override
  _DiarioHomePageState createState() => _DiarioHomePageState();
}

class _DiarioHomePageState extends State<DiarioHomePage> {
  late DiarioService _diarioService;
  late Future<List<Entrada>> _entradas;

  @override
  void initState() {
    super.initState();
    _diarioService = DiarioService(client: http.Client());
    _entradas = _diarioService.obterEntradas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário'),
      ),
      body: FutureBuilder<List<Entrada>>(
        future: _entradas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final entradas = snapshot.data ?? [];

          return ListView.builder(
            itemCount: entradas.length,
            itemBuilder: (context, index) {
              final entrada = entradas[index];
              return ListTile(
                title: Text(entrada.titulo),
                subtitle: Text(entrada.data),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormulario() async {
    final tituloController = TextEditingController();
    final conteudoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova Entrada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: conteudoController,
                decoration: const InputDecoration(labelText: 'Conteúdo'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final novaEntrada = Entrada(
                  id: 0,
                  data: DateTime.now().toString(),
                  titulo: tituloController.text,
                  conteudo: conteudoController.text,
                );

                try {
                  await _diarioService.criarEntrada(novaEntrada);
                  setState(() {
                    _entradas = _diarioService.obterEntradas();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao criar entrada: $e')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
