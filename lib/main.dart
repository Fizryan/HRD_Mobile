import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/hrd_c.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/views/home_v.dart';
import 'package:hrd_system_project/views/login_v.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginControl()),
        ChangeNotifierProvider(create: (context) => HrdController()),
      ],
      child: MaterialApp(
        title: 'HRD System',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<LoginControl>(
          builder: (context, loginControl, child) {
            if (loginControl.loginStatus == LoginStatus.success &&
                loginControl.loggedInUser != null) {
              return HomeView(user: loginControl.loggedInUser!);
            }
            return const LoginView();
          },
        ),
      ),
    );
  }
}
