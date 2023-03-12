class DataModel {
  String? earthquakeId;
  String? title;
  String? date;
  var mag;
  var depth;
  Geojson? geojson;
  LocationProperties? locationProperties;
  String? rev;
  String? dateStamp;
  String? dateDay;
  String? dateHour;
  String? timestamp;
  String? locationTz;

  DataModel(
      {this.earthquakeId,
        this.title,
        this.date,
        this.mag,
        this.depth,
        this.geojson,
        this.locationProperties,
        this.rev,
        this.dateStamp,
        this.dateDay,
        this.dateHour,
        this.timestamp,
        this.locationTz});

  DataModel.fromJson(Map<String, dynamic> json) {
    earthquakeId = json['earthquake_id'];
    title = json['title'];
    date = json['date'];
    mag = json['mag'];
    depth = json['depth'];
    geojson =
    json['geojson'] != null ? Geojson.fromJson(json['geojson']) : null;
    locationProperties = json['location_properties'] != null
        ? LocationProperties.fromJson(json['location_properties'])
        : null;
    rev = json['rev'];
    dateStamp = json['date_stamp'];
    dateDay = json['date_day'];
    dateHour = json['date_hour'];
    timestamp = json['timestamp'];
    locationTz = json['location_tz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earthquake_id'] = earthquakeId;
    data['title'] = title;
    data['date'] = date;
    data['mag'] = mag;
    data['depth'] = depth;
    if (geojson != null) {
      data['geojson'] = geojson!.toJson();
    }
    if (locationProperties != null) {
      data['location_properties'] = locationProperties!.toJson();
    }
    data['rev'] = rev;
    data['date_stamp'] = dateStamp;
    data['date_day'] = dateDay;
    data['date_hour'] = dateHour;
    data['timestamp'] = timestamp;
    data['location_tz'] = locationTz;
    return data;
  }
}

class Geojson {
  String? type;
  List<double>? coordinates;

  Geojson({this.type, this.coordinates});

  Geojson.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class LocationProperties {
  ClosestCity? closestCity;
  ClosestCity? epiCenter;
  List<Airports>? airports;

  LocationProperties({this.closestCity, this.epiCenter, this.airports});

  LocationProperties.fromJson(Map<String, dynamic> json) {
    closestCity = json['closestCity'] != null
        ? ClosestCity.fromJson(json['closestCity'])
        : null;
    epiCenter = json['epiCenter'] != null
        ? ClosestCity.fromJson(json['epiCenter'])
        : null;
    if (json['airports'] != null) {
      airports = <Airports>[];
      json['airports'].forEach((v) {
        airports!.add(Airports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (closestCity != null) {
      data['closestCity'] = closestCity!.toJson();
    }
    if (epiCenter != null) {
      data['epiCenter'] = epiCenter!.toJson();
    }
    if (airports != null) {
      data['airports'] = airports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClosestCity {
  String? name;

  ClosestCity({this.name});

  ClosestCity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Airports {
  double? distance;
  String? name;
  String? code;
  Geojson? coordinates;

  Airports({this.distance, this.name, this.code, this.coordinates});

  Airports.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    name = json['name'];
    code = json['code'];
    coordinates = json['coordinates'] != null
        ? Geojson.fromJson(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['name'] = name;
    data['code'] = code;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    return data;
  }
}
