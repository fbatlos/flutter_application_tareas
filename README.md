# Descripción APP Tareas

La aplicación es un gestor de tareas con todas sus funcionalidades, además de añadirle la separación de las dos entidades usuario y administrador. Consta de los siguientes documentos/colecciones:

## 1. Usuario
- **username:** `String` → Nombre del usuario.
- **email:** `String` → Correo usado para el registro.
- **password:** `String` → Contraseña del usuario.
- **dirección:** `Direccion` → Dirección del usuario.
- **roles:** `String?` → Entidad que representa a la persona registrada.

## 2. Dirección
- **municipio:** `String`
- **provincia:** `String`

## 3. Tareas
- **titulo:** `String` → Título de la tarea a realizar.
- **cuerpo:** `String` → Descripción de la tarea.
- **username:** `String` → Usuario al que pertenece la tarea.
- **fecha_pub:** `Date` → Día y hora en que se publicó la tarea.
- **completada:** `Boolean` → `true` si está completada, `false` si no.

---

# Planteamiento de la Gestión

Se han creado **2 entidades DTO** para facilitar el ingreso de datos en la API.  
- El **Login** retorna un **token**.  
- El **Register** retorna un **AuthResponse** con el token y datos no sensibles del usuario.  

---

# Endpoints a Revisar

## 1. Gestión de Usuario
- **POST `/usuarios/login`**  
  - Recibe un `LoginUsuarioDTO`, lo compara con la BD en MongoDB y retorna un token si es válido.  
- **POST `/usuarios/register`**  
  - Recibe un `UsuarioRegisterDTO` y procesa los datos en la BD junto con la API externa de **GeoAPI** para la dirección.  

## 2. Gestión de Tareas  
El sistema distingue entre roles (`usuario` y `admin`):  

- **GET `/tareas`** → Devuelve todas las tareas del usuario. El admin puede ver todas.  
- **POST `/tarea`** → Crea una tarea con el `username` correspondiente. Si es admin, puede asignar tareas a otros usuarios.  
- **PUT `/tarea`** → Actualiza la tarea asignada.  
- **DELETE `/tarea`** → El usuario elimina sus propias tareas; el admin puede eliminar cualquier tarea.  

---

# Lógica de Negocio

## 1. Usuario  
Restricciones:  
- No se permite repetir `username` ni `email`.  
- La contraseña debe tener más de **5 caracteres**.  
- Se compara la contraseña con su repetición.  

## 2. Dirección  
Se usa una API externa para validar:  
- Que el **municipio** y la **provincia** existan y tengan sentido.  

## 3. Tareas  
Restricciones:  
- El **título** no puede estar vacío.  
- El **cuerpo** no puede estar vacío.   
- **El administrador tiene acceso total** a todas las funciones.  

---

# Restricciones de Seguridad

### 1. Autenticación  
- Todos los endpoints requieren **JWT**, excepto `login` y `register`.  

### 2. Autorización  
- Solo los **administradores** pueden gestionar todas las tareas.  
- Los **usuarios** solo pueden gestionar sus propias tareas.  

### 3. Validación de Datos  
- Se validan entradas para evitar **inyecciones** y errores.  
- Se valida el formato de **email** al registrar usuarios.  

### 4. Control de Acceso  
- Restricciones a nivel de servicio para evitar que un usuario acceda a datos ajenos.  

---

# Excepciones y Códigos de Estado

| Código  | Descripción |
|---------|------------|
| **500** | INTERNAL SERVER ERROR → Error inesperado en el servidor. |
| **400** | BAD REQUEST → Datos inválidos (ej. email mal formado). |
| **401** | UNAUTHORIZED → No autenticado (token inválido o ausente). |
| **403** | FORBIDDEN → Sin permisos para realizar la acción. |
| **404** | NOT FOUND → Recurso no encontrado. |
| **409** | CONFLICT → Conflicto en la BD (ej. usuario ya registrado). |

# Códigos de Estado Buenos

| Código  | Descripción |
|---------|------------|
| **200** | OK → La pertición salió de forma exitosa. |
| **201** | Created → Se usa en post, se creó sin problema en la base de datos (ej. añadir una Tarea). |
| **204** | Not Content → Usado en delete, eliminó de la base de datos lo necesario (ej. eliminar una Tarea). |

---


[Ver código en GitHub](https://github.com/fbatlos/flutter_application_tareas/blob/c41e5dbc290858345333adc174a45e054f18972a/lib/API/api_service.dart#L8-L23)

```dart
// Código aquí


class ApiService {
  static Future<String?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/usuarios/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> getTareas(String token) async {
    final url = Uri.parse("$baseUrl/tareas/tareas");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }

  static Future<dynamic?> postTareas(
      String token, TareaInsertDTO tareainsertada) async {
    final url = Uri.parse("$baseUrl/tareas/tarea");
    final response = await http.post(
      url,
      body: jsonEncode(tareainsertada.toJson()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      print(errorBody);
      return errorBody["message"];
    }
  }

  static Future<dynamic?> deleteTareas(String token, String idTarea) async {
    final url = Uri.parse("$baseUrl/tareas/tarea/$idTarea");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 204) {
      return null;
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }

  static Future<dynamic> putTareas(
      String token, Map<String, dynamic> tareaUpdate) async {
    final url = Uri.parse("$baseUrl/tareas/tarea");
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(tareaUpdate));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      return errorBody["message"];
    }
  }
}
```
**Video demostrativo**:  

🔗 [Ver video en Google Drive - Full Tarea](https://drive.google.com/file/d/1GI8h6LjEnLaCC2x_0n2JsMrA8NyE9aYk/view?usp=sharing](https://drive.google.com/file/d/1HnSRGRpa5BT9qPMO0g_BtPTYLHvxw5Tn/view?usp=sharing))
