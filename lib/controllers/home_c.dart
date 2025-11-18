import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/menu_c.dart';
import 'package:hrd_system_project/models/menu_m.dart';
import 'package:hrd_system_project/models/user_m.dart';

// #region home controller
class HomeController extends ChangeNotifier {
  int _selectedIndex = 0;
  List<NavigationItem> _menuItems = [];

  int get selectedIndex => _selectedIndex;
  List<NavigationItem> get menuItems => _menuItems;

  Widget get currentPage {
    if (_menuItems.isEmpty) {
      return const Center(child: Text("No pages available"));
    }
    return _menuItems[_selectedIndex].page;
  }

  void init(User user) {
    _menuItems = MenuConfig.getMenusForRole(user);
    if (_menuItems.isNotEmpty && _selectedIndex >= _menuItems.length) {
      _selectedIndex = 0;
    }
    notifyListeners();
  }

  void onItemTapped(int index) {
    if (index < 0 || index >= _menuItems.length) return;
    _selectedIndex = index;
    notifyListeners();
  }
}

// #endregion
