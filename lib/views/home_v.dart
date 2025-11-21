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

            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      UserColor.getColorByRole(user.role),
                      UserColor.getColorByRole(
                        user.role,
                      ).withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: UserColor.getColorByRole(
                        user.role,
                      ).withValues(alpha: 0.3),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppBar(
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          hasMenu
                              ? controller
                                    .menuItems[controller.selectedIndex]
                                    .icon
                              : Icons.dashboard,
                          color: AppColor.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          hasMenu
                              ? controller
                                    .menuItems[controller.selectedIndex]
                                    .label
                              : 'No pages available',
                          style: const TextStyle(
                            color: AppColor.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColor.transparent,
                  elevation: 0,
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppColor.white,
                        ),
                        onPressed: () {
                          context.read<LoginController>().logout();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            body: hasMenu
                ? controller.currentPage
                : const Center(child: Text('No pages available')),

            bottomNavigationBar: hasMenu
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black87.withValues(alpha: 0.06),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      backgroundColor: AppColor.white,
                      currentIndex: controller.selectedIndex,
                      onTap: controller.onItemTapped,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: UserColor.getColorByRole(user.role),
                      unselectedItemColor: AppColor.grey600,
                      showUnselectedLabels: true,
                      selectedFontSize: 12,
                      unselectedFontSize: 11,
                      selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 0,
                      items: controller.menuItems.map((item) {
                        final isSelected =
                            controller.menuItems.indexOf(item) ==
                            controller.selectedIndex;
                        return BottomNavigationBarItem(
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(item.icon, size: 24),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: UserColor.getColorByRole(user.role),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
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
