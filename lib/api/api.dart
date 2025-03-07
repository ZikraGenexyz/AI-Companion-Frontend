import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/chats.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {
  List<Chats> _chats = [];
  bool _isLoading = true;
  String _error = '';

  List<Chats> get chats => [..._chats];
  bool get isLoading => _isLoading;
  String get error => _error;

  ChatProvider() {
    print('ChatProvider initialized');
    fetchChat();
  }

  Future<void> fetchChat() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      // Choose URL based on platform and environment
      String baseUrl;
      // if (Platform.isIOS) {
      //   // Use localhost for iOS simulator
      //   baseUrl = 'http://localhost:8000';
        
      //   // If you're using a physical device, uncomment and use your computer's IP:
      //   // baseUrl = 'http://192.168.1.XXX:8000'; // Replace with your computer's IP
      // } else {
      //   // Android emulator
      //   baseUrl = 'http://10.0.2.2:8000';
      // }

      baseUrl = 'https://ai-companion-backend-chi.vercel.app';

      final url = Uri.parse('$baseUrl/apis/v1?format=json');
      print('Fetching from URL: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _chats = data.map<Chats>((json) => Chats.fromJson(json)).toList();
        print('Chats loaded: ${_chats.length}');
      } else {
        _error = 'Server error: ${response.statusCode}';
        print(_error);
      }
    } catch (error) {
      _error = 'Error: $error';
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
