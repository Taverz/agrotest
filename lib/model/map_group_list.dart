
import 'map_group_object.dart';

class ListGroupObject {
  List<ListGroup>? listGroup;

  ListGroupObject({this.listGroup});

  ListGroupObject.fromJson(Map<String, dynamic> json) {
    listGroup = json["listGroup"] == null ? null : (json["listGroup"] as List).map((e) => ListGroup.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(listGroup != null) {
      _data["listGroup"] = listGroup?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ListGroup {
  String? idGroup;
  List<MapGroupObject>? listObject;

  ListGroup({this.idGroup, this.listObject});

  ListGroup.fromJson(Map<String, dynamic> json) {
    idGroup = json["id_group"];
    listObject = json["listObject"] == null ? null : (json["listObject"] as List).map((e) => MapGroupObject.fromMap(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_group"] = idGroup;
    if(listObject != null) {
      _data["listObject"] = listObject?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}
