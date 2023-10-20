import 'dart:convert';
import 'package:storyapp_flutter/utils/auth.dart';
import '../model/model.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class Repository {
  final baseUrl = "https://story-api.dicoding.dev/v1";
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<LoginResponse> login(String email, String password) async {
    try {
      // Map data = {'email': email, 'password': password};
      final response = await http.post(Uri.parse("$baseUrl/login"),
          headers: headers,
          body: jsonEncode(
              <String, String>{'email': email, 'password': password}));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final responseLogin = LoginResponse.fromJson(responseData);

        AuthManager.saveAuthToken(responseLogin.loginResult.token);
        print("Login is success");
        print("token:${responseLogin.loginResult.token}");
        return responseLogin;
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode} with error ${response.body}');
      }
    } catch (e) {
      print('An error occurred while making the HTTP request: $e');
      throw e;
    }
  }

  Future<ResponseApi> register(
      String name, String email, String password) async {
    try {
      // Map data = {'name': name, 'email': email, 'password': password};
      final response = await http.post(Uri.parse("$baseUrl/register"),
          headers: headers,
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'password': password
          }));

      if (response.statusCode == 201) {
        final Map<String, dynamic> register = json.decode(response.body);
        print("register is success");
        return ResponseApi.fromJson(register);
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while making the HTTP request.');
    }
  }

  Future<List<ListStory>> getStory() async {
    final url = '$baseUrl/stories';

    final token = await AuthManager.getAuthToken();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        print(token);
        final responseData = jsonDecode(response.body);
        final List<dynamic> storiesJson = responseData['listStory'];
        final List<ListStory> stories = storiesJson.map((storyJson) {
          return ListStory.fromJson(storyJson);
        }).toList();

        return stories;
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}, with : ${response.body}');
      }
    } catch (e) {
      print('An error occurred while making the HTTP request.');
      throw e;
    }
  }

  Future<List<ListStory>> getStoryMap(String token) async {
    // String? token = await AuthManager.getAuthToken();
    final url = '$baseUrl/stories?location=1';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> storiesJson = responseData['listStory'];
        final List<ListStory> stories = storiesJson.map((storyJson) {
          return ListStory.fromJson(storyJson);
        }).toList();

        return stories;
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}, with : ${response.body} token:$token and : ${response.headers}');
      }
    } catch (e) {
      print('An error occurred while making the HTTP request.');
      throw e;
    }
  }

  Future<ResponseApi> postStory(StoryModel story) async {
    final token = await AuthManager.getAuthToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/stories'));
      request.headers.addAll(headers);

      request.fields['description'] = story.description;

      final file = await http.MultipartFile.fromPath('photo', story.photo.path,
          contentType:
              MediaType('image', 'jpeg')); // Adjust content type as needed

      request.files.add(file);

      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        print("Upload is success");
        return ResponseApi.fromJson(responseData);
      } else {
        print('Post failed with status: ${response.statusCode}');
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}, with : ${response.stream.bytesToString()}');
      }
    } catch (e) {
      print('An error occurred while making the HTTP request: $e');
      throw e;
    }
  }
}
