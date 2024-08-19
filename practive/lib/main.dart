import 'package:flutter/material.dart';
import '../homePage.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

//차트
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInPage());
  }
}

// 로그인/가입 페이지

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String inputEmail = "";
  String inputPw = "";

  String serverURL =
      "http://127.0.0.1:8000/check"; // local : http://211.243.47.122:3001/check

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            color: Color.fromRGBO(226, 249, 255, 1),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "TOOK",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "가볍게, 툭",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        // add email validation
                        if (value == null || value.isEmpty) {
                          return '학번을 입력해주세요.';
                        }

                        bool numberValid = RegExp(r'^[0-9]+$').hasMatch(value);
                        if (!numberValid) {
                          return '숫자를 입력해주세요';
                        }
                        inputEmail = value;

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: '학번',
                        hintText: '학번을 입력하세요.',
                        prefixIcon: Icon(Icons.account_balance),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '공백은 안 된다!!';
                        }

                        if (value.length < 6) {
                          return '최소한 6글자 이상으로!!';
                        }

                        inputPw = value;

                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: '비밀번호',
                          hintText: '비밀번호를 입력해주세요.',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '로그인',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final response = await http.post(
                                Uri.parse(serverURL), //서버에 요청
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8'
                                }, //여기 변환인가?
                                body: jsonEncode(<String, String>{
                                  'email': inputEmail,
                                  'password': inputPw
                                }) //전달할 값

                                );

                            if (response.statusCode == 200) //서버 에러 확인
                            {
                              final result =
                                  jsonDecode(response.body); // response 번역

                              if (result['exists'] == true) // 있으면 페이지 이동
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('자네는 강팀이 될 수 없다네.')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('서버 오류가 발생했습니다.')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
