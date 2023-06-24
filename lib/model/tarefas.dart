import 'package:get/get.dart';

import '../repositories/tarefas_repositories.dart';

TarefasRepository repository = TarefasRepository();

class Tarefas extends GetxController {
  late final String tarefa;
  late bool concluido;
  late String objectId;

  Tarefas(
      {required this.tarefa, required this.concluido, required this.objectId});

  factory Tarefas.fromJson(Map<String, dynamic> json) {
    return Tarefas(
      tarefa: json['tarefa'] as String,
      concluido: json['concluida'] as bool,
      objectId: json['objectId'] as String,
    );
  }

  void atualizarTarefa(bool value) {
    concluido = value;
    repository.atualizarTarefa(objectId, concluido);
  }

  addTarefa(String tarefa) async {
    final novoObject = await repository.adicionarTarefa(tarefa);
    return novoObject;
  }

  void removerTarefa(String tarefa) {
    repository.apagaTarefa(tarefa);
  }
}
