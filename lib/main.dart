import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/views/home_v.dart';
import 'package:hrd_system_project/views/login_v.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
    Hive.registerAdapter(UserAdapter());
  }

  if (!Hive.isAdapterRegistered(UserRoleAdapter().typeId)) {
    Hive.registerAdapter(UserRoleAdapter());
  }

  if (!Hive.isBoxOpen('users')) {
    await Hive.openBox<User>('users');
  }

  await UserService.seedUsers(dummyUsers);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUsers()),
        ChangeNotifierProvider(create: (_) => LoginController()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR-Connect',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<LoginController>(
        builder: (context, loginController, child) {
          if (loginController.status == LoginStatus.success &&
              loginController.loggedInUser != null) {
            return HomeView(user: loginController.loggedInUser!);
          }
          return const LoginView();
        },
      ),
    );
  }
}
