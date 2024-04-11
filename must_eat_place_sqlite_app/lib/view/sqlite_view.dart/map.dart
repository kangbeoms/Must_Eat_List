import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class SqliteMap extends StatefulWidget {
  const SqliteMap({super.key});

  @override
  State<SqliteMap> createState() => _SqliteMapState();
}

class _SqliteMapState extends State<SqliteMap> {

  late MapController mapController;
  late LatLng latlng;
  var argument = Get.arguments;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    latlng = LatLng(argument[0], argument[1]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: const Text('맛집 위치')
          ),
        ),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: latlng,
          initialZoom: 17.0
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80,
                height: 100,
                point: latlng,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        argument[2],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(
                      Icons.pin_drop,
                      size: 50,
                      color: Colors.red,
                    )
                  ],
                )
              ),
            ]
          )  
        ]
      ),
    );
  }
}