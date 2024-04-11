import 'package:flutter/material.dart';
import 'package:must_eat_place_sqlite_app/view/list_mysql.dart';
import 'package:must_eat_place_sqlite_app/view/list_sqlite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: tabController, children: const [
        ListSqlite(),
        ListMysql(),
      ]),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        child: TabBar(
            controller: tabController,
            indicatorPadding: const EdgeInsets.all(5),
            tabs: const [
              Tab(
                icon: Icon(Icons.food_bank),
                text: 'sqlite 맛집 리스트',
              ),
              Tab(
                icon: Icon(Icons.fastfood_outlined),
                text: 'mysql 맛집 리스트',
              ),
            ]),
      ),
    );
  }
}
