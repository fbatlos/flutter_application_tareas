import 'package:flutter/material.dart';
import 'package:flutter_application_tareas/Model/TareaInsertDTO.dart';
import '../API/api_service.dart';
import '../Model/Tarea.dart';
import '../Utils/Utils.dart';
import 'package:intl/intl.dart';

class TareasListScreen extends StatefulWidget {
  final String token;
  final String username;

  TareasListScreen({required this.token, required this.username});

  @override
  _TareasListScreenState createState() => _TareasListScreenState();
}

class _TareasListScreenState extends State<TareasListScreen> {
  List<dynamic> _tareas = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _esAdmin = false;

  @override
  void initState() {
    super.initState();
    verificarAdmin();
    obtenerTareas();
  }

  Future<void> obtenerTareas() async {
    try {
      var tareas = await ApiService.getTareas(widget.token);

      if (tareas == null) {
        throw Error();
      } else {
        setState(() {
          _tareas = tareas;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "No hay tareas disponibles.";
        _isLoading = false;
      });
    }
  }

  Future<void> verificarAdmin() async {
    bool admin = await esAdmin(widget.token);
    setState(() {
      _esAdmin = admin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          "Tareas",
          style: TextStyle(color: Color.fromARGB(255, 248, 248, 248)),
        ),
        backgroundColor: Colors.blueGrey[900],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 248, 248, 248),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  )
                : _tareas.isEmpty
                    ? Center(
                        child: Text(
                          "No hay tareas disponibles",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tareas.length,
                        itemBuilder: (context, index) {
                          var tarea = _tareas[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: tarea["completada"]
                                ? Colors.green[300]
                                : Colors.blueGrey[700],
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                tarea["titulo"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "${DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.parse(tarea["fecha_pub"]))}${_esAdmin ? " - ${tarea["username"]}" : ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  tarea["completada"]
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: tarea["completada"]
                                      ? Colors.greenAccent
                                      : Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tarea["completada"] = !tarea["completada"];
                                    ApiService.putTareas(widget.token, tarea);
                                  });
                                },
                              ),
                              onLongPress: () => {
                                _opcionesTarea(context, widget.token, tarea,
                                    () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await obtenerTareas();
                                })
                              },
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[700],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _addTareaDialog(context, widget.token, widget.username, () async {
            setState(() {
              _isLoading = true;
            });
            await obtenerTareas();
          }, _esAdmin);
        },
      ),
    );
  }
}

void _mostrarAlertaError(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(mensaje, style: TextStyle(color: Colors.red)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

void _opcionesTarea(BuildContext context, String token, dynamic tarea,
    Function actualizarLista) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Opciones", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarea["titulo"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              tarea["cuerpo"],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Divider(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var resultado =
                  await ApiService.deleteTareas(token, tarea["_id"]);
              Navigator.of(context).pop();

              if (resultado is String) {
                _mostrarAlertaError(context, resultado);
              } else {
                actualizarLista();
              }
            },
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void _addTareaDialog(BuildContext context, String token, String username,
    Function actualizarLista, bool esAdmin) {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController cuerpoController = TextEditingController();
  final TextEditingController usernameController =
      TextEditingController(text: username);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Añadir Tarea"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: cuerpoController,
              decoration: InputDecoration(labelText: "Cuerpo"),
            ),
            if (esAdmin)
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              String titulo = tituloController.text;
              String cuerpo = cuerpoController.text;
              String usuarioAsignado = usernameController.text;

              var resultado = await ApiService.postTareas(
                token,
                TareaInsertDTO(
                  titulo: titulo,
                  cuerpo: cuerpo,
                  username: usuarioAsignado,
                ),
              );

              Navigator.of(context).pop();

              if (resultado is String) {
                _mostrarAlertaError(context, resultado);
              } else {
                actualizarLista();
              }
            },
            child: Text("Guardar"),
          ),
        ],
      );
    },
  );
}
