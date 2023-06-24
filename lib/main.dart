import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_tarefas_dio/controllers/controller_tarefas.dart';
import 'package:get_it/get_it.dart';
import 'package:lista_tarefas_dio/repositories/tarefas_repositories.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt.registerSingleton<ControllerTarefas>(ControllerTarefas(),
      signalsReady: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lista de Tarefas',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController tarefaTextController = TextEditingController();
  HomePage({Key? key}) : super(key: key);

  void openModal(BuildContext context) {
    final controller = Get.put(ControllerTarefas());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tarefaTextController,
                  decoration: const InputDecoration(
                    labelText: "Digite o nome da tarefa",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String novaTarefa = tarefaTextController.text;
                    if (novaTarefa.isNotEmpty) {
                      controller.adcionarTarefa(novaTarefa);
                      tarefaTextController.clear();
                      Navigator.pop(
                          context); // Fechar o modal após adicionar a tarefa
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerTarefas());
    controller.buscarDados();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.tarefas.isEmpty) {
            return const Text('Nenhuma tarefa encontrada.');
          } else {
            return ListView.builder(
              itemCount: controller.tarefas.length,
              itemBuilder: (context, index) {
                var tarefa = controller.tarefas[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    final tarefaRemovida = controller.tarefas[index];
                    controller.removerTarefa(tarefa.objectId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Tarefa removida: ${tarefaRemovida.tarefa}'),
                    ));
                  },
                  child: ListTile(
                    title: Text(tarefa.tarefa),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tarefa.concluido ? 'Concluído' : 'Pendente'),
                        Switch(
                          value: tarefa.concluido,
                          onChanged: (value) {
                            controller.atualizarTarefa(index, value);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
