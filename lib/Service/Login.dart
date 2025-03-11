import 'package:flutter/material.dart';
import 'package:flutter_application_tareas/Service/Register.dart';
import '../API/api_service.dart';
import '../Service/TareasList.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Preguntar si esta bien implementado
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  // Login funcional con validación
  void login() async {
    //Es una doble validación propia de Flutter la cual es usada para mostrar los errores de campos obligatorios.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String username = usernameController.text;
    String password = passwordController.text;

    String? token = await ApiService.login(username, password);
    //Cambiamos el estado para que se repinte sin ningún problema
    setState(() {
      _isLoading = false;
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TareasListScreen(
              token: token,
              username: username,
            ),
          ),
        );
      } else {
        _errorMessage = "Usuario o contraseña incorrectos";
      }
    });
  }

//Creación del apartado visual con sus comprobaciones y su distinción de admin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 50, 56),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                //Le asignamos una key la cual usaremas para realizar una doble verificación
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 38, 50, 56),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Usuario",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "El usuario es obligatorio" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) =>
                          value!.length < 5 ? "Mínimo 5 caracteres" : null,
                    ),
                    SizedBox(height: 10),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.blueGrey[800],
                            ),
                            child: Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                    SizedBox(height: 20),
                    //Text button para dirigirnos a la ventana del register
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
