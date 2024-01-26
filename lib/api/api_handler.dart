import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrabble/shared_prefs/shared_prefs.dart';

import '../global.dart';
import '../models/user.dart';

class ApiHandler {
  ApiHandler._();
  static ApiHandler get instance => ApiHandler._();

  Future<int> addUser(User user) async {
    final url = Uri.parse('$baseUrl/add_user');

    var request = http.MultipartRequest('POST', url);

    request.fields['username'] = user.username;
    request.fields['email'] = user.email;
    request.fields['password'] = user.password;

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      user.image.path,
    ));

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('User registered successfully');
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }

      return response.statusCode;
    } catch (error) {
      print('Error: $error');
      return 500;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/get_user_details');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      userData = jsonDecode(response.body);
      DataSharedPreferences().saveUser(userData);
      return {'success': true, 'message': 'Login successful'};
    } else {
      final error = jsonDecode(response.body)['error'];
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> checkGame(String username) async {
    try {
      final Uri url = Uri.parse('$baseUrl/checkGame');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return {
          'data': json.decode(response.body),
          'statusCode': response.statusCode
        };
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> createGame(String username) async {
    try {
      final Uri url = Uri.parse('$baseUrl/newGame');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'data': json.decode(response.body),
          'statusCode': response.statusCode
        };
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> playerjoined(int gameId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/playerJoined?game_id=$gameId');
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(jsonDecode(response.body));
        return json.decode(response.body);
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> getOpponentDetails(String username) async {
    try {
      final Uri url =
          Uri.parse('$baseUrl/get_opponent_details?username=$username');
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(jsonDecode(response.body));
        return json.decode(response.body);
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> endGame(int gameId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/newGame');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'game_id': gameId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'data': json.decode(response.body),
          'statusCode': response.statusCode
        };
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> addTurn(
      {required String char,
      required int rowIndex,
      required int colIndex,
      required String playerId,
      required int gameId}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/addMove');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "char": char,
          "rowIndex": rowIndex,
          'colIndex': colIndex,
          'game_id': gameId,
          "player_id": playerId
        }),
      );

      if (response.statusCode == 201) {
        print(response.body);
        return json.decode(response.body);
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }

  Future<Map<String, dynamic>> getTurns(int gameId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/getMove?game_id=$gameId');
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return json.decode(response.body);
      } else {
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Exception: $e');
      return {'error': 'An error occurred', 'statusCode': 404};
    }
  }
}
