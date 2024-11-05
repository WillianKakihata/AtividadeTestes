class Entrada {
  final int id;
  final String data;
  final String titulo;
  final String conteudo;

  Entrada({
    required this.id,
    required this.data,
    required this.titulo,
    required this.conteudo,
  });

  factory Entrada.fromJson(Map<String, dynamic> json) {
    return Entrada(
      id: int.tryParse(json['id'].toString()) ?? 0,
      data: json['data'],
      titulo: json['titulo'],
      conteudo: json['conteudo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'titulo': titulo,
      'conteudo': conteudo,
    };
  }
}
