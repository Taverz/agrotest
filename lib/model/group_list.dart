// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

const List<GroupListItem> listGroupTest = [
  GroupListItem(title: "Group 11 K5", description: "Обьект на севере", id: "p9d23hnd2323dwd8ny292"),
  GroupListItem(title: "Поле 23 М4", description: "Работы в поле", id: "2893yrn398rn23yfbdp9efbdwa"),
];

/// Группа обьектов
class GroupListItem {
  final String id;
  final String title;
  final String description;
  const GroupListItem({
    required this.id,
    required this.title,
    required this.description,
  });


  GroupListItem copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return GroupListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory GroupListItem.fromMap(Map<String, dynamic> map) {
    return GroupListItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupListItem.fromJson(String source) => GroupListItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupListItem(id: $id, title: $title, description: $description)';

  @override
  bool operator ==(covariant GroupListItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;
}
