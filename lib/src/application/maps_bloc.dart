


import 'dart:async';

import 'package:cooperatives_prototype_one/src/application/maps_event.dart';
import 'package:cooperatives_prototype_one/src/application/maps_state.dart';
import 'package:cooperatives_prototype_one/src/infraestructure/get_position.dart';
import 'package:cooperatives_prototype_one/src/infraestructure/routes_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsBloc{

  StreamController<MapsEvent> _mapsInput = StreamController();
  StreamController<MapsState> _mapsOutput = StreamController.broadcast();

  Stream<MapsState> get mapsStream => _mapsOutput.stream;
  StreamSink<MapsEvent> get sendMapEvent => _mapsInput.sink;

  MapsBloc(){
    _mapsInput.stream.listen(_onEvent);
  }


  void _onEvent(MapsEvent event) async {

    if(event is GetPosition){
      final getPosition = PositionProvider();
      _mapsOutput.add(PositionLoaded(position: await getPosition.getPosition(), coordinates: await getPosition.getCoordinates()));
      /*final provider = new RoutesProviders(new LatLng(10.449967296386747, -73.254279349752522), new LatLng(10.467202889540042, -73.25640611350538));
      provider.getPoints();*/
    }else if(event is GetRoute){
      final provider = RoutesProviders(event.startRoute, event.endRoute);
      _mapsOutput.add(RouteLoaded(points: await provider.getPoints()));
    }
  }

  void dispose(){
   _mapsInput.close();
   _mapsOutput.close();
  }
}

final mapsBloc = MapsBloc();

