
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:must_eat_place_sqlite_app/view/sqlite_view.dart/insert.dart';
import 'package:must_eat_place_sqlite_app/view/sqlite_view.dart/map.dart';
import 'package:must_eat_place_sqlite_app/view/sqlite_view.dart/update.dart';
import 'package:must_eat_place_sqlite_app/vm/database_handler.dart';

class ListSqlite extends StatefulWidget {
  const ListSqlite({super.key});

  @override
  State<ListSqlite> createState() => _ListSqliteState();
}

class _ListSqliteState extends State<ListSqlite> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child:  Text('나만의 맛집 리스트'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Get.to(const SqliteInsert())!.then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add_box_rounded)
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: handler.queryReview(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Get.to(const SqliteUpdate(), arguments: snapshot.data![index])!.then((value) => setState(() {}));
                          },
                          icon: Icons.edit,
                          label: '수정',
                          backgroundColor: Colors.blue,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ]
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            _showDiaglog();
                            await handler.deleteReview(snapshot.data![index].seq);
                          },
                          icon: Icons.delete_outline,
                          label: '삭제',
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ]
                    ),
                    child: GestureDetector(
                      onTap: () => Get.to(const SqliteMap(), arguments: [
                        snapshot.data![index].lat,
                        snapshot.data![index].lng,
                        snapshot.data![index].name,
                      ]),
                      child: Card(
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/3,
                              height: MediaQuery.of(context).size.height/6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.memory(
                                  snapshot.data![index].image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/3*1.78,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data![index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/3*1.4,
                                        height: MediaQuery.of(context).size.height/16,
                                        child: Text(
                                          snapshot.data![index].estimate,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/5.5,),
                                        Text(snapshot.data![index].phone)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    CircularProgressIndicator()
                ],
              )
            );
          }
        },
      ),
    );
  }

  
  _showDiaglog() {
    Get.defaultDialog(
      title: '완료',
      middleText: '항목이 삭제되었습니다.',
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            setState(() {});
          },
          child: const Text('확인')
        )
      ]
    );
  }
}