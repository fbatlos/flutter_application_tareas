import 'package:flutter/material.dart';
import 'API/api_service.dart';
import 'TareasList.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _token;
  String? _errorMessage;

  // Login funcional
  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // Llamada al login y obtención del token
    String? token = await ApiService.login(username, password);

    setState(() {
      if (token != null) {
        _token = token;
        _errorMessage =
            null; // Si el login es exitoso, quitamos el mensaje de error
        print("Login exitoso: $_token");
        // Después de obtener el token, navego a la pantalla de tareas
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TareasListScreen(
              token: _token!,
              username: username,
            ),
          ),
        );
      } else {
        _errorMessage = "Usuario o contraseña incorrectos"; // Mostramos error
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 10),

            // Mostrar mensaje de error si existe
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("Iniciar sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
