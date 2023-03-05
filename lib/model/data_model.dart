

class DataModel {
  var mag;
  double? lng;
  double? lat;
  String? lokasyon;
  var depth;
  List<double>? coordinates;
  String? title;
  String? timestamp;
  String? dateStamp;
  String? date;
  String? hash;
  String? hash2;

  DataModel(
      {this.mag,
        this.lng,
        this.lat,
        this.lokasyon,
        this.depth,
        this.coordinates,
        this.title,
        this.timestamp,
        this.dateStamp,
        this.date,
        this.hash,
        this.hash2});

  DataModel.fromJson(Map<String, dynamic> json) {
    mag = json['mag'];
    lng = json['lng'];
    lat = json['lat'];
    lokasyon = json['lokasyon'];
    depth = json['depth'];
    coordinates = json['coordinates'].cast<double>();
    title = json['title'];
    timestamp = json['timestamp'];
    dateStamp = json['date_stamp'];
    date = json['date'];
    hash = json['hash'];
    hash2 = json['hash2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mag'] = mag;
    data['lng'] = lng;
    data['lat'] = lat;
    data['lokasyon'] = lokasyon;
    data['depth'] = depth;
    data['coordinates'] = coordinates;
    data['title'] = title;
    data['timestamp'] = timestamp;
    data['date_stamp'] = dateStamp;
    data['date'] = date;
    data['hash'] = hash;
    data['hash2'] = hash2;
    return data;
  }
}