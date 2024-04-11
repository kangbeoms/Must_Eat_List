
import 'dart:typed_data';

class SaveData {
  int? seq;
  String name;
  String phone;
  double lat;
  double lng;
  Uint8List image;
  String estimate;
  String initdate;


  SaveData ({
    this.seq,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.image,
    required this.estimate,
    required this.initdate,
 
  });

  SaveData.fromMap(Map<String, dynamic> res)
    : seq = res['seq'],
      name = res['name'],
      phone = res['phone'],
      lat = res['lat'],
      lng = res['lng'],
      image = res['image'],
      estimate = res['estimate'],
      initdate = res['initdate'];

}