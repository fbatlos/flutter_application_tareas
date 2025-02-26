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
  bool _isLoading = false;

  // Login funcional
  void login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String username = usernameController.text;
    String password = passwordController.text;

    String? token = await ApiService.login(username, password);

    setState(() {
      _isLoading = false;
      if (token != null) {
        _token = token;
        print("Login exitoso: $_token");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TareasListScreen(
              token: _token!,
              username: username,
            ),
          ),
        );
      } else {
        _errorMessage = "Usuario o contraseña incorrectos";
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
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: login,
                    child: Text("Iniciar sesión"),
                  ),
          ],
        ),
      ),
    );
  }
}
