import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/map_group_list.dart';
import '../model/map_group_object.dart';
import 'other/data.dart';
import 'other/default_location_marker.dart';
import 'other/location_marker_layer.dart';
import 'other/only_one_click.dart';
import 'other/style.dart';

// ignore: must_be_immutable
class PageGroupMap extends StatelessWidget {
  final ListGroup groupObj;
  PageGroupMap({super.key, required this.groupObj});

  final Connectivity _connectivity = Connectivity();
  double currentZoom = 14.0;
  late MapController mapController;
  late List<Marker> markers;
  Timer? timer;
  int ticket = 6;
  bool reverse = false;

  @override
  Widget build(BuildContext context) {
    mapController = MapController();
    markers = _generateMap(groupObj);
    OnlyOneClick.lastClick = null;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              onTapBack: () {
                OnlyOneClick.oneClick(() {
                  Navigator.pop(context);
                });
              },
              onTapSettings: () {},
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: _connectivity.checkConnectivity(),
                      builder:
                          (contx, AsyncSnapshot<ConnectivityResult> snapshot) {
                        if (snapshot.data == null) {
                          return const CupertinoActivityIndicator();
                        }
                        if ((snapshot.data as ConnectivityResult) ==
                                ConnectivityResult.none ||
                            (snapshot.data as ConnectivityResult) ==
                                ConnectivityResult.bluetooth ||
                            (snapshot.data as ConnectivityResult) ==
                                ConnectivityResult.other) {
                          return Center(
                            child: Container(
                              child: const Text("Интернет отсутствует!!"),
                            ),
                          );
                        }
                        return Stack(
                          children: [
                            Positioned.fill(child: _map(context)),
                            //TODO: icon button from fitBounds
                            //TODO: icon (+) and (-) Zoom
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Выравнять карту по крайним обьектам
  void _initListObject() {
    (LatLng, LatLng) result = _getCornerViaDistance();
    final LatLng latlngCorner1 = result.$1;
    final LatLng latlngCorner2 = result.$2;

    /// Это нужно для того чтобы все обьекты поместились в экран
    final LatLngBounds latLngBounds =
        LatLngBounds(latlngCorner1, latlngCorner2);
    try {
      // mapController.centerZoomFitBounds(latLngBounds);

      /// Это нужно для того чтобы карта прогрузилась нормально перед fitBounds
      // final double curretnZoom = mapController.zoom;
      final LatLng curretnCenter = mapController.center;
      _zoom(curretnCenter);
    } catch (e) {}
    try {
      mapController.fitBounds(
        latLngBounds,
        options: const FitBoundsOptions(padding: EdgeInsets.all(40)),
      );
    } catch (e) {}
  }

  void _zoom(LatLng currentCenter) async {
    currentZoom = currentZoom - 1;
    mapController.move(currentCenter, currentZoom);
    // currentZoom = currentZoom - 1;
    // mapController.move(currentCenter, currentZoom);
  }

  /// Узнать крайние обьекты
  (LatLng, LatLng) _getCornerViaDistance() {
    //TODO: algoritm search 2 object other corner
    final MapGroupObject elem1 = groupObj.listObject!.last;
    final MapGroupObject elem2 = groupObj.listObject!.first;
    double max = 0.0;
    double min = 0.0;
    LatLng? maxL;
    LatLng? minL;
    groupObj.listObject!.forEach((element) {
      if(element.lat > max){
        max = element.lat;
        maxL = LatLng(element.lat, element.lon);
      } 
      if(element.lon > max){
        max = element.lon;
        maxL = LatLng(element.lat, element.lon);
      }
      if(element.lat < min){
        min = element.lat;
        minL = LatLng(element.lat, element.lon);
      }
      if(element.lon < min){
        min = element.lat;
        minL = LatLng(element.lat, element.lon);
      }
    });
    var latLng_Corner1 = LatLng(elem1.lat, elem1.lon);
    var latLng_Corner2 = LatLng(elem2.lat, elem2.lon);
    latLng_Corner1 = maxL!;
    latLng_Corner2 = minL!;

    return (latLng_Corner1, latLng_Corner2);
  }

  List<CircleMarker> circlesWW = [];
  List<MarkerIsTimer> locationMarkerLayerListWW = [];
  List<Marker> _generateMap(ListGroup dataFromMarker) {
    if (dataFromMarker.listObject == null) {
      return [];
    }
    final List<Marker> markers = List.generate(
      dataFromMarker.listObject!.length,
      (index) => Marker(
        width: 50,
        height: 50,
        point: LatLng(
          dataFromMarker.listObject![index].lat,
          dataFromMarker.listObject![index].lon,
        ),
        builder: (_) => GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            child: Column(
              children: [
                const Icon(
                  Icons.toys_rounded,
                  color: Colors.red,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  dataFromMarker.listObject![index].name,
                  style: const TextStyle(fontSize: 6),
                ),
              ],
            ),
          ),
          onTap: () {
            //TODO: описание открыть
          },
        ),
      ),
    );

    // final List<CircleMarker> circles = List.generate(
    //   dataFromMarker.listObject!.length,
    //   (index) => CircleMarker(
    //     //radius marker
    //     point: LatLng(
    //       dataFromMarker.listObject![index].lat,
    //       dataFromMarker.listObject![index].lon,
    //     ),
    //     useRadiusInMeter: true,
    //     color: Colors.blue.withOpacity(0.3),
    //     borderStrokeWidth: 3.0,
    //     borderColor: Colors.blue,
    //     radius: 100, //radius
    //   ),
    // );
    // circlesWW = circles;

    final List<MarkerIsTimer> locationMarkerLayerList =
        List.generate(dataFromMarker.listObject!.length, (index) {
      return MarkerIsTimer(
        reverse: index.isEven ? false : true,
        longitude: dataFromMarker.listObject![index].lon,
        latitude: dataFromMarker.listObject![index].lat,
        radius: dataFromMarker.listObject![index].radius_object,
      );
    });
    locationMarkerLayerListWW = locationMarkerLayerList;

    return markers;
  }

  Widget _map(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initListObject();
    });

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        /// Max zoom нужен для того чтобы избежать ошибки с белым экраном
        maxZoom: 18.0,
        minZoom: 9.0,
        zoom: currentZoom,
      ),
      children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
            ),
            SizedBox(),
            // MarkerLayer(
            //   //TODO: маркеры - это обекты в виде иконок на карте, располлогаются по координатам
            //   markers: markers,
            // ),
          ] +
          locationMarkerLayerListWW,
    );
  }

  /// Для просмотра описания при нажатии на иконку
  void _openAlertDialogDescription(String idObject) {
    //TODO: открыть диаологовое окно с описанием обьекта
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
      children: [
        _backButton(),
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

class MarkerIsTimer extends StatefulWidget {
  final bool reverse;
  final double longitude;
  final double latitude;
  final double radius;
  const MarkerIsTimer(
      {super.key,
      required this.reverse,
      required this.latitude,
      this.radius = 200,
      required this.longitude});

  @override
  State<MarkerIsTimer> createState() => _MarkerIsTimerState();
}

class _MarkerIsTimerState extends State<MarkerIsTimer> {
  Timer? timer;
  int ticket = 6;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  _startTimer() async {
    await Future.delayed(Duration(seconds: 2));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (mounted) {
          if (widget.reverse) {
            setState(() {
              // reverse = true;
              if ((ticket) <= 0) {
                ticket = 360;
              }
              ticket -= 6;
            });
          } else
            setState(() {
              // reverse = false;
              if ((ticket) > 360) {
                ticket = 6;
              }
              ticket += 6;
            });
        }
      } catch (e) {}

      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocationMarkerLayer(
      tick360: ticket,
      radius: widget.radius,
      reverse: widget.reverse,
      position: LocationMarkerPosition(
        /// Направление движения
        accuracy: 29.8700008392334 + (widget.reverse ? 20 : 0),
        longitude: widget.longitude,
        latitude: widget.latitude,
      ),
      heading: LocationMarkerHeading(
        accuracy: 0.3141592653589793,
        heading: -1.8799179792404177,
      ),
      style: LocationMarkerStyle(
        marker: GestureDetector(
          onTap: () {
            //TODO: описание открыть
          },
          child: const DefaultLocationMarker(
            color: Colors.green,
            child: Icon(
              Icons.car_repair_rounded,
              color: Colors.white,
            ),
          ),
        ),
        markerSize: const Size.square(40),
        accuracyCircleColor: Colors.orange.withOpacity(0.1),
        headingSectorColor: Colors.pink.withOpacity(0.8),
        headingSectorRadius: 100,
      ),
    );
    ;
  }
}
