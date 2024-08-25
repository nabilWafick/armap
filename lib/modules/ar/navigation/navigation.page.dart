import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';

class ARNavigationPage extends ConsumerStatefulWidget {
  final RouteData routeData;
  const ARNavigationPage({
    super.key,
    required this.routeData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ARNavigationPageState();
}

class _ARNavigationPageState extends ConsumerState<ARNavigationPage> {
  ArCoreController arCoreController;
  Position currentPosition;
  List<ArCoreNode> routeNodes = [];
  StreamSubscription<Position> positionStream;
  final double visibilityThreshold = 100; // meters
  List<LatLng> routePoints = [];
  List<TurnPoint> turnPoints = [];
  int currentTurnPointIndex = 0;
  FlutterTts flutterTts = FlutterTts();
  Timer routeUpdateTimer;
  bool isLoading = true;
  String errorMessage;

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.microphone,
      Permission.camera,
    ].request();

    if (statuses[Permission.location].isGranted &&
        statuses[Permission.microphone].isGranted &&
        statuses[Permission.camera].isGranted) {
      _initializeApp();
    } else {
      setState(() {
        errorMessage = "Required permissions not granted";
      });
    }
  }

  void _initializeApp() {
    _initLocationTracking();
    _fetchRoute();
    _initTextToSpeech();
    routeUpdateTimer = Timer.periodic(
        const Duration(minutes: 5), (timer) => _checkRouteValidity());
  }

  void _initLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
      setState(() {
        currentPosition = position;
      });
      _updateARView();
      _checkNextTurnPoint();
    }, onError: (e) {
      setState(() {
        errorMessage = "Error tracking location: $e";
      });
    });
  }

  void _initTextToSpeech() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
    } catch (e) {
      setState(() {
        errorMessage = "Error initializing text-to-speech: $e";
      });
    }
  }

  Future<void> _fetchRoute() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final cachedRoute = prefs.getString('cached_route');

      if (cachedRoute != null) {
        _parseRouteData(json.decode(cachedRoute));
      } else {
        const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
        final url =
            'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.origin.latitude},${widget.origin.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&key=$apiKey';

        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          await prefs.setString('cached_route', json.encode(decodedResponse));
          _parseRouteData(decodedResponse);
        } else {
          throw Exception('Failed to fetch route: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching route: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _parseRouteData(Map<String, dynamic> routeData) {
    routePoints.clear();
    turnPoints.clear();

    final routes = routeData['routes'] as List;
    if (routes.isNotEmpty) {
      final legs = routes[0]['legs'] as List;
      if (legs.isNotEmpty) {
        final steps = legs[0]['steps'] as List;
        for (var step in steps) {
          final startLocation = step['start_location'];
          final endLocation = step['end_location'];
          routePoints.add(LatLng(startLocation['lat'], startLocation['lng']));
          routePoints.add(LatLng(endLocation['lat'], endLocation['lng']));

          if (step['maneuver'] != null) {
            turnPoints.add(TurnPoint(
              location: LatLng(startLocation['lat'], startLocation['lng']),
              maneuver: step['maneuver'],
              instruction: step['html_instructions'],
            ));
          }
        }
      }
    }
    _placeRouteObjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _placeRouteObjects();
  }

  void _placeRouteObjects() {
    if (currentPosition == null) return;

    int objectsPlaced = 0;
    const int maxObjects =
        50; // Limit the number of objects to improve performance

    for (int i = 0; i < routePoints.length && objectsPlaced < maxObjects; i++) {
      LatLng point = routePoints[i];
      if (_placeObjectAtLocation(
          point.latitude, point.longitude, i == routePoints.length - 1)) {
        objectsPlaced++;
      }
    }

    for (TurnPoint turnPoint in turnPoints) {
      if (objectsPlaced >= maxObjects) break;
      if (_placeTurnObject(turnPoint)) {
        objectsPlaced++;
      }
    }
  }

  bool _placeObjectAtLocation(double lat, double lon, bool isDestination) {
    vector.Vector3 position = _calculateARPosition(lat, lon);
    if (_isWithinVisibilityThreshold(position)) {
      String objectUrl = isDestination
          ? 'https://example.com/destination_object.sfb'
          : 'https://example.com/route_point_object.sfb';

      ArCoreReferenceNode node = ArCoreReferenceNode(
        objectUrl: objectUrl,
        position: position,
        scale: vector.Vector3(0.2, 0.2, 0.2),
      );
      arCoreController.addArCoreNode(node).catchError((e) {
        print("Error loading AR object: $e");
      });
      routeNodes.add(node);
      return true;
    }
    return false;
  }

  bool _placeTurnObject(TurnPoint turnPoint) {
    vector.Vector3 position = _calculateARPosition(
        turnPoint.location.latitude, turnPoint.location.longitude);
    if (_isWithinVisibilityThreshold(position)) {
      String objectUrl =
          'https://example.com/${turnPoint.maneuver}_turn_object.sfb';

      ArCoreReferenceNode node = ArCoreReferenceNode(
        objectUrl: objectUrl,
        position: position,
        scale: vector.Vector3(0.3, 0.3, 0.3),
      );
      arCoreController.addArCoreNode(node).catchError((e) {
        print("Error loading AR turn object: $e");
      });
      routeNodes.add(node);
      return true;
    }
    return false;
  }

  vector.Vector3 _calculateARPosition(double lat, double lon) {
    double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude, currentPosition.longitude, lat, lon);
    double bearingInRadians = Geolocator.bearingBetween(
            currentPosition.latitude, currentPosition.longitude, lat, lon) *
        (pi / 180);

    double x = distanceInMeters * sin(bearingInRadians);
    double z = -distanceInMeters * cos(bearingInRadians);

    return vector.Vector3(x, 0, z);
  }

  bool _isWithinVisibilityThreshold(vector.Vector3 position) {
    return position.distanceTo(vector.Vector3.zero()) <= visibilityThreshold;
  }

  void _updateARView() {
    for (ArCoreNode node in routeNodes) {
      arCoreController.removeNode(nodeName: node.name).catchError((e) {
        print("Error removing AR node: $e");
      });
    }
    routeNodes.clear();
    _placeRouteObjects();
  }

  void _checkNextTurnPoint() {
    if (currentTurnPointIndex < turnPoints.length) {
      double distanceToNextTurn = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        turnPoints[currentTurnPointIndex].location.latitude,
        turnPoints[currentTurnPointIndex].location.longitude,
      );

      if (distanceToNextTurn < 50) {
        // 50 meters before the turn
        _speakInstruction(turnPoints[currentTurnPointIndex].instruction);
        currentTurnPointIndex++;
      }
    }
  }

  void _speakInstruction(String instruction) async {
    try {
      await flutterTts.speak(instruction);
    } catch (e) {
      print("Error speaking instruction: $e");
    }
  }

  void _checkRouteValidity() async {
    double distanceToRoute = _calculateDistanceToRoute();
    if (distanceToRoute > 100) {
      // If more than 100 meters off route
      await _fetchRoute(); // Re-fetch the route
      _updateARView();
    }
  }

  double _calculateDistanceToRoute() {
    double minDistance = double.infinity;
    for (LatLng point in routePoints) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        point.latitude,
        point.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    return minDistance;
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    positionStream?.cancel();
    routeUpdateTimer?.cancel();
    super.dispose();
  }
}
