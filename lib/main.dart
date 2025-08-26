import 'package:flutter/material.dart';
import 'package:gp_calc/semester_input_screen.dart';
import 'package:gp_calc/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_screen.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved grade scale
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedScale = prefs.getString('gradeScale') ?? '4.0';
  GradeScaleManager.setScale(savedScale);

  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'System',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/semester-input': (context) => const SemesterInputScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }

}




/*
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
    home: HomeScreen(),
  ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(

      backgroundColor: Colors.amber,
      title: Row(children: [

        Text('🧮  '), SizedBox(width: 8), Text('CGPA Calculator')]
    ),
    )

      ,body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              alignment: Alignment.topCenter,
                width: 200,

               // color: Colors.amber,
                child:Column(children: [
                  Text('🎓',style: TextStyle(fontSize: 50),),
                 SizedBox.fromSize(size: Size(50, 50)),

                  Text('Track your academic journey'),
                SizedBox.fromSize(size: Size(30, 30)),
                  Text('calculate your gp and keep track of your academic progress'),
                ],)

            ),
            SizedBox.fromSize(size: Size(50, 50)),
            Container(
              width: 300,
              height: 50,
             // color: Colors.amber,
              child:ElevatedButton(onPressed: (){}, child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('🧮'), SizedBox(width: 8), Text('Calculate CGPA ')]
              )

              ),
            ),
            SizedBox.fromSize(size: Size(50, 50)),

             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children:[
                    Container(
                      child: ElevatedButton(onPressed: (){}, child:
                       Row(children: [Text('📜'), SizedBox(width: 8), Text('History '),],),
                      ),
                    ),
                    SizedBox.fromSize(size: Size(50, 50)),
                    Container(
                        child: ElevatedButton(onPressed: (){}, child:
                        Row(children: [Text('⚙️'), SizedBox(width: 8), Text('Settings '),],
                        ),
                      ),
                    ),
                  ],
              ),

            SizedBox.fromSize(size: Size(50, 50)),
            Container(
                width: 200,

               // color: Colors.amber,
                child:Column(children: [
                  Text('Quick Stats'),
                  SizedBox.fromSize(size: Size(50, 50)),
                  Text('Last Calculated: 2023-01-01'),
                  Text('Semester 6 GPA: 3.8'),
                ],
                )

            ),


          ],
        ),
      ),
        );
  }
}




*/
