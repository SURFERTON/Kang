import 'package:flutter/material.dart';
import 'package:practive/signCheckPage.dart';
import '../homePage.dart';
import '../main.dart';
// 서버 통신
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String inputName = "";
  String inputEmail = "";
  String inputPw = "";
  String inputRole = "";

  bool _isPasswordVisible = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String serverURL = "http://211.243.47.122:3001/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
