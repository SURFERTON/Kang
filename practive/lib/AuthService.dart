import 'package:flutter/material.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

class AuthService {
  String? _token; // JWT 토큰을 저장할 변수
  final String loginUrl = 'http://127.0.0.1:8000/token'; // 로그인 엔드포인트

  // 로그인 시 서버로 요청을 보내 토큰을 받음
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      return true;
    } else {
      return false;
    }
  }

  // 토큰을 이용해 인증된 요청 보내기
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/me');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  // 로그아웃 시 토큰 삭제
  void logout() {
    _token = null;
  }
}
