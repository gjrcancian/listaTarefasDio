import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class TarefasRepository {
  RxList _tarefas = RxList();

  Future carregarTarefas() async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': '7nrcVlVgXcaLbKQfxz1sgpEqeeqGKcnJh22vGSq3',
      'X-Parse-REST-API-Key': 'MhJpnmwzNEpBjJhVf94jJC4t9OdZabAhxExgCXRG',
    };

    final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/tarefas'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _tarefas.addAll(data['results']);
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    return (_tarefas);
  }

  Future<void> apagaTarefa(String objectId) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': '7nrcVlVgXcaLbKQfxz1sgpEqeeqGKcnJh22vGSq3',
      'X-Parse-REST-API-Key': 'MhJpnmwzNEpBjJhVf94jJC4t9OdZabAhxExgCXRG',
    };

    try {
      final response = await http.delete(
        Uri.parse('https://parseapi.back4app.com/classes/tarefas/$objectId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _tarefas.removeWhere((cepData) => cepData['objectId'] == objectId);
      } else {
        print('Erro ao excluir o CEP: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição HTTP: $e');
    }
  }

  Future<void> atualizarTarefa(String objectId, bool concluido) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': '7nrcVlVgXcaLbKQfxz1sgpEqeeqGKcnJh22vGSq3',
      'X-Parse-REST-API-Key': 'MhJpnmwzNEpBjJhVf94jJC4t9OdZabAhxExgCXRG',
    };

    final response = await http.put(
      Uri.parse('https://parseapi.back4app.com/classes/tarefas/$objectId'),
      headers: headers,
      body: jsonEncode({'concluida': concluido}),
    );

    if (response.statusCode == 200) {
      final updatedData = {'objectId': objectId, 'concluido': concluido};
      final index = _tarefas
          .indexWhere((tarefaData) => tarefaData['objectId'] == objectId);
      if (index != -1) {
        _tarefas[index] = updatedData;
      }
    } else {
      print('Erro ao atualizar a tarefa: ${response.statusCode}');
    }
  }

  Future<String> adicionarTarefa(String tarefa) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': '7nrcVlVgXcaLbKQfxz1sgpEqeeqGKcnJh22vGSq3',
      'X-Parse-REST-API-Key': 'MhJpnmwzNEpBjJhVf94jJC4t9OdZabAhxExgCXRG',
    };

    final body = jsonEncode({
      'tarefa': tarefa,
      'concluida': false,
    });

    try {
      final response = await http.post(
        Uri.parse('https://parseapi.back4app.com/classes/tarefas'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final novoObjectId = data['objectId'] as String;

        final novaTarefa = {
          'objectId': novoObjectId,
          'tarefa': tarefa,
          'concluida': false,
        };
        _tarefas.add(novaTarefa);

        return novoObjectId;
      } else {
        print('Erro ao adicionar a tarefa: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição HTTP: $e');
    }

    return '';
  }
}
