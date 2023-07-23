import 'dart:convert';

/// Обьекты на карте
class MapGroupObject {
  /// Тип обьекта, для того чтобы знать как его отрисовать
  final TypeObjectMachine type;
  /// В какую сторону движется
  final DirectionObjectMachine direction;
  /// rule < 90  or  > -90
  final double lat;
  /// rule < 90  or  > -90
  final double lon;
  final String id_object;
  final String name;
  final double radius_object;
  const MapGroupObject({
    required this.type,
    required this.direction,
    required this.lat,
    required this.lon,
    required this.id_object,
    required this.name,
    required this.radius_object,
  });

  MapGroupObject copyWith({
    TypeObjectMachine? type,
    DirectionObjectMachine? direction,
    double? lat,
    double? lon,
    String? id_object,
    String? name,
    double? radius_object,
  }) {
    return MapGroupObject(
      type: type ?? this.type,
      direction: direction ?? this.direction,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      id_object: id_object ?? this.id_object,
      name: name ?? this.name,
      radius_object: radius_object ?? this.radius_object,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toStr(),
      'direction': direction.toStr(),
      'lat': lat,
      'lon': lon,
      'id_object': id_object,
      'name': name,
      'radius_object': radius_object,
    };
  }

  factory MapGroupObject.fromMap(Map<String, dynamic> map) {
    double lat = map['lat'] as double;
    if(!(lat.toInt() < 90 && lat.toInt() > -90))
    throw Exception("Errore parse: lat < 90 && lat > -90");

    double lon = map['lon'] as double;
    if(!(lon.toInt() < 90 && lon.toInt() > -90))
    throw Exception("Errore parse: lon < 90 && lon > -90");

    return MapGroupObject(
      type: TypeObjectMachineXX.convert(map['type'] as String),
      direction: DirectionObjectMachineXX.convert(map['direction'] as String),
      lat: lat,
      lon: lon,
      id_object: map['id_object'] as String,
      name: map['name'] as String,
      radius_object: map['radius_object'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MapGroupObject.fromJson(String source) => MapGroupObject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MapGroupObject(type: $type, direction: $direction, lat: $lat, lon: $lon, id_object: $id_object, name: $name, radius_object: $radius_object)';
  }

  @override
  bool operator ==(covariant MapGroupObject other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.direction == direction &&
      other.lat == lat &&
      other.lon == lon &&
      other.id_object == id_object &&
      other.name == name &&
      other.radius_object == radius_object;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      direction.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      id_object.hashCode ^
      name.hashCode ^
      radius_object.hashCode;
  }
}


enum TypeObjectMachine{
  circular
}
enum DirectionObjectMachine{
  right,
  left
}

extension DirectionObjectMachineXX on DirectionObjectMachine{
  String  toStr() => name.toString();
  static DirectionObjectMachine convert(String en){
    switch(en){
      case "right":
        return DirectionObjectMachine.right;
      case "left":
        return DirectionObjectMachine.left;
      default:
        throw Exception("DirectionObjectMachine convert errore data: $en");
    }
  }
}

extension TypeObjectMachineXX on TypeObjectMachine{
  String  toStr() => name.toString();
  static TypeObjectMachine convert(String en){
    switch(en){
      case "circular":
        return TypeObjectMachine.circular;
      default:
        throw Exception("DirectionObjectMachine convert errore data: $en");
    }
  }
}
