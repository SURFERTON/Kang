import 'package:flutter/material.dart';
import '../request.dart';
import '../response.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0; // 0: 프로필 1: 검색 2: 관리 3: 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Text(
                  "TOOK",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 64,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.fromLTRB(100, 100, 100, 0),
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(226, 249, 255, 1)),
                ),
                onPressed: () {
                  _onMenuButtonPressed(1);
                },
                child: Text(
                  '요청할래요!',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.fromLTRB(100, 20, 100, 0),
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(226, 249, 255, 1)),
                ),
                onPressed: () {
                  _onMenuButtonPressed(2);
                },
                child: Text(
                  '해줄래요!',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuButtonPressed(int index) {
    if (index == 1) {
      // Navigate to RequestPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RequestPage()),
      );
    } else if (index == 2) {
      // Navigate to ResponsePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResponsePage()),
      );
    }
  }
}
