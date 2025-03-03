import 'package:flutter/material.dart';
import 'package:flutter_application_tareas/Model/Direccion.dart';
import 'package:flutter_application_tareas/Model/UsuarioRegisterDTO.dart';
import 'package:flutter_application_tareas/Service/Login.dart';
import 'package:flutter_application_tareas/Service/TareasList.dart';
import '../API/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Forma para que los cuestionarios tengan mayor validación
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final TextEditingController municipioController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();

  String? _errorMessage;
  bool isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String passwordRepeat = passwordRepeatController.text;
    String municipio = municipioController.text;
    String provincia = provinciaController.text;

    Direccion direccion = Direccion(municipio: municipio, provincia: provincia);
    UsuarioRegisterDTO usuarioRegistrado = UsuarioRegisterDTO(
      username: username,
      email: email,
      password: password,
      passwordRepeat: passwordRepeat,
      direccion: direccion,
    );

    dynamic? authResponse = await ApiService.register(usuarioRegistrado);

    setState(() {
      isLoading = false;
      if (authResponse is String) {
        _errorMessage = authResponse;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TareasListScreen(
              token: authResponse["token"]!,
              username: username,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("Registro", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Crea tu cuenta",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[900]),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(usernameController, "Usuario"),
                          _buildTextField(
                              emailController, "Correo electrónico"),
                          _buildTextField(passwordController, "Contraseña",
                              isPassword: true),
                          _buildTextField(
                              passwordRepeatController, "Repetir Contraseña",
                              isPassword: true),
                          _buildTextField(municipioController, "Municipio"),
                          _buildTextField(provinciaController, "Provincia"),
                          SizedBox(height: 10),
                          if (_errorMessage != null)
                            Text(_errorMessage!,
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[900],
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Registrarse",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                            child: Text("Ya tengo una cuenta.",
                                style: TextStyle(color: Colors.blueGrey[700])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) return "Campo obligatorio";
          if (label == "Repetir Contraseña" && value != passwordController.text)
            return "Las contraseñas no coinciden";
          return null;
        },
      ),
    );
  }
}
