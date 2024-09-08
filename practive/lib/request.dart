import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../homePage.dart';
import '../main.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String inputToAdd = "";
  String inputFromAdd = "";
  String inputOption = "";
  String inputHour = "12";
  String inputMinute = "00";
  String inputPrice = "";
  String inputTip = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String serverURL = "http://211.243.47.122:3001/post";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: formKey,
          child: Container(
            color: const Color.fromRGBO(226, 249, 255, 1),
            child: Center(
              child: Container(
                width: 300,
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "여기로 가져다 주세요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 30, // Reduced height
                            child: TextFormField(
                              style: TextStyle(fontSize: 12),
                              onChanged: (value) {
                                inputToAdd = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 8.0), // Adjust padding
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.location_pin),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "여기서 TOOK 해주세요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 30, // Reduced height
                            child: TextFormField(
                              style: TextStyle(fontSize: 12),
                              onChanged: (value) {
                                inputFromAdd = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 8.0), // Adjust padding
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.location_pin),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "요청사항이에요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 120, // Increased height (2x)
                      child: TextFormField(
                        style: TextStyle(fontSize: 14), // Slightly larger text
                        maxLines: null, // Allows for multiple lines
                        expands: true,
                        onChanged: (value) {
                          inputOption = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0), // Adjust padding
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "이때까지 해주세요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: inputHour,
                            items: List.generate(
                              24,
                              (index) => (index + 1).toString().padLeft(2, '0'),
                            )
                                .map((hour) => DropdownMenuItem(
                                      value: hour,
                                      child: Text(hour),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                inputHour = value!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: inputMinute,
                            items: List.generate(
                              60,
                              (index) => index.toString().padLeft(2, '0'),
                            )
                                .map((minute) => DropdownMenuItem(
                                      value: minute,
                                      child: Text(minute),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                inputMinute = value!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "상품 가격은 이만큼이에요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 30, // Reduced height
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(fontSize: 12), // Adjust text size
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          inputPrice = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0), // Adjust padding
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "팁으로 이만큼 드려요.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 30, // Reduced height
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(fontSize: 12), // Adjust text size
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          inputTip = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0), // Adjust padding
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '요청하기',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          DateTime now = DateTime.now();

                          // 현재 날짜의 시와 분을 입력된 값으로 변경
                          DateTime modifiedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            int.parse(inputHour),
                            int.parse(inputMinute),
                            now.second,
                            now.millisecond,
                            now.microsecond,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(inputToAdd)),
                          );

                          final url = Uri.parse(serverURL);
                          final response = await http.post(
                            url,
                            headers: {
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization': 'Bearer $token',
                            },
                            body: jsonEncode({
                              "destination": inputToAdd,
                              "departure": inputFromAdd,
                              "content": inputOption,
                              "end_time": modifiedDateTime.toIso8601String(),
                              "pay_amount": int.parse(inputPrice),
                              "tip": int.parse(inputTip)
                            }),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.body)),
                          );

                          if (response.statusCode == 200) {
                            final result = jsonDecode(response.body);
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('요청에 성공하였어요!')),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                            return json.decode(response.body);
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
