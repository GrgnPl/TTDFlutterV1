import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum TabItem { home, education, duty, profile }

Map<TabItem, String> tabName = {
  TabItem.home: "Ana Sayfa",
  TabItem.duty: "Görevler",
  TabItem.profile: "Profil",
};

const Map<TabItem, IconData> tabIcons = {
  TabItem.home: Icons.home_outlined,
  TabItem.duty: Icons.notifications_outlined,
  TabItem.profile: Icons.person_2_outlined,
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key? key, required this.onSelectedTab, required this.tabController, required this.unreadNotificationCount}) : super(key: key);
  final ValueChanged<TabItem> onSelectedTab;
  final TabController tabController;
  int unreadNotificationCount;

  static const _notchMarginSize = 8.0; // Notch size changed to 8

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF172A31),
      notchMargin: _notchMarginSize,
      shape: const CircularNotchedRectangle(),
      child: TabBar(
        controller: tabController,
        labelPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        onTap: (value) {
          onSelectedTab(TabItem.values[value]);
        },
        tabs: [
          buildItem(TabItem.home),
          buildItem(TabItem.duty, unreadNotificationCount),
          buildItem(TabItem.profile),
        ],
      ),
    );
  }

  Tab buildItem(TabItem tabItem, [int unreadNotificationCount = 0]) {
    final color = Colors.white;
    return Tab(
        iconMargin: EdgeInsets.zero,
        icon: Stack(
          children: [
            Icon(
              tabIcons[tabItem],
              color: color,
            ),
            if (tabItem == TabItem.education && unreadNotificationCount > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF172A31),
                  ),
                  child: Text(
                    '$unreadNotificationCount',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        child: Text(
          '${tabName[tabItem]}',
          style: TextStyle(fontSize: 12.sp,color: Colors.white),
        ));
  }
}