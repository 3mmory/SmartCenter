import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stack and Wrap',
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Stack(
                alignment: Alignment.center,
                children: [

                  Container(
                    width: 160,
                    height: 220,
                    color: Colors.green,
                  ),

                  Container(
                    width: 160,
                    height: 180,
                    color: Colors.red,
                  ),

                  Container(
                    width: 160,
                    height: 140,
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 16),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [

                  Container(
                    width: 80,
                    height: 100,
                    color: Colors.orange,
                  ),

                  Container(
                    width: 80,
                    height: 100,
                    color: Colors.purple,
                  ),

                  Container(
                    width: 80,
                    height: 100,
                    color: Colors.yellow,
                  ),

                  Container(
                    width: 80,
                    height: 100,
                    color: Colors.cyan,
                  ),
                  Container(
                    width: 80,
                    height: 100,
                    color: Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
