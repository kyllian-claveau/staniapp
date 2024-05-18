import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future<Map<String, dynamic>?> getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token == null) {
      return null; // Si le token est null, l'utilisateur n'est pas authentifié
    }

    print('JWT Token: $token'); // Afficher le token JWT dans le terminal

    // Décodage du token JWT pour extraire l'ID de l'utilisateur
    final parts = token.split('.');
    if (parts.length != 3) {
      return null; // Le token JWT est invalide
    }
    final payload = parts[1];
    final String decodedPayload = utf8.decode(base64.decode(base64.normalize(payload)));
    final Map<String, dynamic> jwtData = json.decode(decodedPayload);
    final userId = jwtData['id'];

    print('User ID: $userId'); // Afficher l'ID de l'utilisateur dans le terminal

    var fullUrl = 'http://10.0.2.2:8000/api/users/$userId';

    final response = await http.get(
      Uri.parse(fullUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      // Si la requête est réussie, renvoyer les informations de l'utilisateur
      final userData = json.decode(response.body);
      return userData;
    } else {
      // Si la requête échoue, renvoyer null
      return null;
    }
  }
}
