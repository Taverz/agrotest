import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/group_list.dart';
import '../model/map_group_list.dart';
import '../model/test_json_map.dart';
import 'other/only_one_click.dart';
import 'page_group_map.dart';

class PageListGroup extends StatelessWidget {
  const PageListGroup({super.key});

  @override
  Widget build(BuildContext context) {
    OnlyOneClick.lastClick = null;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onTapBack: () {
              Navigator.pop(context);
            }, onTapSettings: () {
              //TODO: Navigation Settings page
            }),
            Expanded(
              child: _ListView(
                listgroup: listGroupTest,
                selectListItem: (String id) =>
                    OnlyOneClick.oneClick(() => _selectListItem(id, context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Имитация получения данных с сервера
  ListGroupObject _getData() {
    return ListGroupObject.fromJson(jsonTest);
  }

  void _selectListItem(String id, BuildContext context) {
    final ListGroupObject listObjData = _getData();
    final ListGroup? findSelect = listObjData.listGroup
        ?.firstWhere((element) => (element.idGroup ?? "") == id);
    if (findSelect == null) {
      throw Exception("no find");
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageGroupMap(
          groupObj: findSelect,
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final Function() onTapBack;
  final Function() onTapSettings;
  const _AppBar({
    super.key,
    required this.onTapBack,
    required this.onTapSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // _backButton(),
        _title(),
        // _settingsButton(),
      ],
    );
  }

  /// Это страница будет находится между друигми, поэтому нужна кнопка возврата
  Widget _backButton() {
    return IconButton(
      onPressed: () {
        onTapBack();
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  Widget _title() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: const Text("Список групп"),
    );
  }

  /// Пока просто настройки, в будущем чтобы ввести каие-то параметры
  Widget _settingsButton() {
    return IconButton(
      onPressed: () {
        onTapSettings();
      },
      icon: const Icon(Icons.settings),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<GroupListItem>? listgroup;
  final Function(String id) selectListItem;
  const _ListView(
      {super.key, required this.listgroup, required this.selectListItem});

  @override
  Widget build(BuildContext context) {
    _reqestPermission();
    return _listView(listgroup);
  }

  void _reqestPermission() async {
    try {
      final locationStatus = await Permission.location.status;
      if (locationStatus.isDenied) {
        await Permission.location.request();
      }
      final locationAlwaysStatus = await Permission.locationAlways.status;
      if (locationAlwaysStatus.isDenied) {
        await Permission.locationAlways.request();
      }
      final locationWhenInUseStatus = await Permission.locationWhenInUse.status;
      if (locationWhenInUseStatus.isDenied) {
        await Permission.locationWhenInUse.request();
      }
      final appTrackingTransparencyStatus =
          await Permission.appTrackingTransparency.status;
      if (appTrackingTransparencyStatus.isDenied) {
        await Permission.appTrackingTransparency.request();
      }
    } catch (e) {}
  }

  Widget _listView(List<GroupListItem>? listgroup) {
    if (listgroup == null) {
      return const Center(
        child: Text("Empty"),
      );
    }

    if (listgroup.isEmpty) {
      return const Center(
        child: Text("Empty"),
      );
    }
    const double bordRadius = 12.0;
    return ListView.builder(
      itemCount: listgroup.length,
      itemBuilder: (context, index) => InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(bordRadius)),
        onTap: () {
          selectListItem(listgroup[index].id);
        },
        child: _itemListView(
          listgroup[index].title,
          listgroup[index].description,
          12.0,
        ),
      ),
    );
  }

  Widget _itemListView(String title, String description, double borderRadius) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            height: 15,
          ),
          Text(description),
        ],
      ),
    );
  }
}
