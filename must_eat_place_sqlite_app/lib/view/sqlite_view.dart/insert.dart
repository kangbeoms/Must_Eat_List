import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_eat_place_sqlite_app/model/save_data.dart';
import 'package:must_eat_place_sqlite_app/vm/database_handler.dart';

class SqliteInsert extends StatefulWidget {
  const SqliteInsert({super.key});

  @override
  State<SqliteInsert> createState() => _SqliteInsertState();
}

class _SqliteInsertState extends State<SqliteInsert> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;
  late DatabaseHandler handler;

  late double latData; // 위도
  late double lngData; // 경도

  ImagePicker picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    latData = 0;
    lngData = 0;
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    handler = DatabaseHandler();
    checkLocationPermission();
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((position) {
      latData = position.latitude;
      lngData = position.longitude;

      setState(() {});
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('맛집 추가하기'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: OutlinedButton(
                        onPressed: () {
                          getImageFromDevice(ImageSource.gallery);
                        },
                        child: const Text('사진 추가')),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 188, 186, 186),
                        ),
                        borderRadius: BorderRadius.circular(7)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3 * 2,
                      height: 150,
                      child: imageFile == null
                          ? Center(
                              child: Text(
                              '이미지를 선택해 주세요.',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ))
                          : Image.file(File(imageFile!.path)),
                    ),
                  ),
                  Padding(
                    // 위치 (위도 경도)
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                          child: Row(
                            children: [
                              const Text('위도 : '),
                              Text('$latData'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                          child: Row(
                            children: [
                              const Text('경도 : '),
                              Text('$lngData'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    // 이름 textField
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: '이름', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    // 전화번호 textField
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                          labelText: '전화번호', border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: SizedBox(
                      width: 400,
                      height: 150,
                      child: TextField(
                        controller: estimateController,
                        decoration: const InputDecoration(
                          labelText: '평가',
                          border: OutlineInputBorder(borderSide: BorderSide()),
                        ),
                        maxLength: 50,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (imageFile == null) {
                          checkImage();
                          return;
                        }
                        insertSQLite();
                        _showDiaglog();
                      },
                      child: const Text('저장하기'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getImageFromDevice(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile = null;
    } else {
      imageFile = XFile(pickedFile.path);
    }
    setState(() {});
  }

  _showDiaglog() {
    Get.defaultDialog(title: '완료', middleText: '리스트가 추가되었습니다.', actions: [
      ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('확인'))
    ]);
  }

  insertSQLite() async {
    await handler.insertReview(SaveData(
        name: nameController.text,
        phone: phoneController.text,
        lat: latData,
        lng: lngData,
        image: await imageFile!.readAsBytes(),
        estimate: estimateController.text,
        initdate: DateTime.now().toString()));
  }

  checkImage() {
    Get.defaultDialog(
        title: '경고',
        middleText: '이미지를 선택해 주세요!',
        barrierDismissible: false,
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('확인'))
        ]);
  }
}
