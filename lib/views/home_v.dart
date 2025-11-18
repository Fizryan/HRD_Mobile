import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/home_c.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:provider/provider.dart';

// #region home
class HomeView extends StatelessWidget {
  final User user;
  const HomeView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()..init(user),
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          final hasMenu = controller.menuItems.isNotEmpty;

          return Scaffold(
            backgroundColor: AppColor.background,

            appBar: AppBar(
              title: Text(
                hasMenu
                    ? controller.menuItems[controller.selectedIndex].label
                    : 'No pages available',
                style: TextStyle(
                  color: UserColor.getTextColorByRole(user.role),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: UserColor.getColorByRole(user.role),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: UserColor.getTextColorByRole(user.role),
                  ),
                  onPressed: () {
                    context.read<LoginController>().logout();
                  },
                ),
              ],
            ),

            body: hasMenu
                ? controller.currentPage
                : const Center(child: Text('No pages available')),

            bottomNavigationBar: hasMenu
                ? Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      backgroundColor: AppColor.background,
                      currentIndex: controller.selectedIndex,
                      onTap: controller.onItemTapped,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: UserColor.getColorByRole(
                        user.role,
                      ).withValues(alpha: 0.8),
                      unselectedItemColor: Colors.grey,
                      showUnselectedLabels: true,
                      items: controller.menuItems.map((item) {
                        return BottomNavigationBarItem(
                          icon: Icon(item.icon),
                          label: item.label,
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

// #endregion
