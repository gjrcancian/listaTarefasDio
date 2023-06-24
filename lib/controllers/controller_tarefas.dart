import 'package:get/get.dart';
import 'package:lista_tarefas_dio/repositories/tarefas_repositories.dart';
import '../model/tarefas.dart';

class ControllerTarefas extends GetxController {
  final TarefasRepository repository = TarefasRepository();
  RxList<Tarefas> tarefas = <Tarefas>[].obs;

  Future<void> buscarDados() async {
    if (tarefas.isEmpty) {
      List<dynamic>? dadosCarregados = await repository.carregarTarefas();
      if (dadosCarregados != null) {
        print('Dados carregados: $dadosCarregados');
        tarefas.assignAll(dadosCarregados.map((item) {
          final tarefa = Tarefas(
            tarefa: item['tarefa'] as String,
            concluido:
                item['concluida'] != null ? item['concluida'] as bool : false,
            objectId: item['objectId'],
          );

          return tarefa;
        }));
      }
    }
  }

  void atualizarTarefa(int index, bool concluido) {
    tarefas[index].concluido = concluido;
    tarefas[index].atualizarTarefa(concluido);
    tarefas.refresh();
  }

  void adcionarTarefa(String novaTarefa) async {
    Tarefas addTarefa = Tarefas(
      tarefa: novaTarefa,
      concluido: false,
      objectId: 'id_da_tarefa',
    );
    final novoObject = await addTarefa.addTarefa(novaTarefa);
    addTarefa.objectId = novoObject;
    tarefas.add(addTarefa);
    tarefas.refresh();
    update();
    print(tarefas);
  }

  void removerTarefa(String index) {
    Tarefas removerTarefa = Tarefas(
      tarefa: 'novaTarefa',
      concluido: false,
      objectId: index,
    );
    removerTarefa.removerTarefa(index);
    tarefas.removeWhere((element) => element.objectId == index);
    tarefas.refresh();
    update();
  }
}
