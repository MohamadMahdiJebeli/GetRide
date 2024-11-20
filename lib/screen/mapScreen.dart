import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:getride/constant/dimens.dart';
import 'package:getride/gen/assets.gen.dart';
import 'package:getride/screen/splashScreen.dart';
import 'package:getride/widget/backButton.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  GeoPoint? originPoint;
  GeoPoint? destinationPoint;
  String distance = "Calculating the distance";
  String originAddress = "Origin Address...";
  String destinationAddress = "Destination Address...";
  bool isSelectingOrigin = true;
  bool isDestinationFinalized = false;
  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(enableTracking: true, unFollowUser: true),
  );

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    mapController.listenerMapSingleTapping.addListener(() async {
      GeoPoint? tappedPoint = mapController.listenerMapSingleTapping.value;
      if (tappedPoint != null) {
        if (isSelectingOrigin) {
          setOrigin(tappedPoint);
          setState(() {
            isSelectingOrigin = false; // بعد از انتخاب مبدا، به حالت انتخاب مقصد تغییر می‌دهیم
          });
        } else if (!isDestinationFinalized) {
          setDestination(tappedPoint);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setOrigin(GeoPoint point) async {
    if (originPoint != null) {
      await mapController.removeMarker(originPoint!);
    }
    originPoint = point;
    await mapController.addMarker(
      originPoint!,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(image: AssetImage(Assets.icons.origin.path), scaleAssetImage: 13),
      ),
    );
  }

  void setDestination(GeoPoint point) async {
    if (destinationPoint != null) {
      await mapController.removeMarker(destinationPoint!);
    }
    destinationPoint = point;
    await mapController.addMarker(
      destinationPoint!,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(image: AssetImage(Assets.icons.origin.path), scaleAssetImage: 13, color: Colors.black),
      ),
    );
    _controller.forward();

    // زوم به مقصد بعد از انتخاب آن
    mapController.setZoom(stepZoom: -1);

    // محاسبه فاصله
    await distance2point(originPoint!, destinationPoint!).then((value) {
      setState(() {
        if (value < 1000) {
          distance = "${value.toInt()} M";
        } else {
          distance = "${value ~/ 1000} Km";
        }
        isDestinationFinalized = true;
        getAddress() async {
          try {
            await placemarkFromCoordinates(originPoint!.latitude, originPoint!.longitude).then((List<Placemark> plist) {
              setState(() {
                originAddress = "${plist.first.locality} ${plist.first.thoroughfare}";
              });
            });
            await placemarkFromCoordinates(destinationPoint!.latitude, destinationPoint!.longitude).then((List<Placemark> plist) {
              setState(() {
                destinationAddress = "${plist.first.locality} ${plist.first.thoroughfare}";
              });
            });
          } catch (e) {}
        }
         getAddress();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            mapIsLoading: SplashScreen(),
            osmOption: const OSMOption(
              userTrackingOption: UserTrackingOption(enableTracking: true, unFollowUser: true),
              zoomOption: ZoomOption(initZoom: 14),
              isPicker: true,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: Column(
              children: [
                if (originPoint == null && isSelectingOrigin)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSelectingOrigin = true;
                      });
                    },
                    child: const Text('Select Starting Location'),
                  ),
                if (originPoint != null && destinationPoint == null && !isSelectingOrigin)
                  ElevatedButton(
                    onPressed: () async {
                      await distance2point(originPoint!, destinationPoint!).then((value) {
                        setState(() async {
                          if (value < 1000) {
                            distance = "${value.toInt()} M";
                          } else {
                            distance = "${value ~/ 1000} Km";
                          }
                          isDestinationFinalized = true;
                          mapController.zoomOut();
                          getAddress() async {
                            try {
                              await placemarkFromCoordinates(originPoint!.latitude, originPoint!.longitude).then((List<Placemark> plist) {
                                setState(() {
                                  originAddress = "${plist.first.locality} ${plist.first.thoroughfare}";
                                });
                              });
                              await placemarkFromCoordinates(destinationPoint!.latitude, destinationPoint!.longitude).then((List<Placemark> plist) {
                                setState(() {
                                  destinationAddress = "${plist.first.locality} ${plist.first.thoroughfare}";
                                });
                              });
                            } catch (e) {}
                          }
                          await getAddress();
                        });
                      });
                    },
                    child: const Text('Select Destination'),
                  ),
                if (originPoint != null && destinationPoint != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  AnimatedContainer(
                                    width: 200,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(Dimens.small)),
                                      color: Color.fromARGB(120, 255, 87, 34),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(originAddress, style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedContainer(
                                      width: 200,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(Dimens.small)),
                                        color: Colors.black38,
                                      ),
                                      duration: const Duration(seconds: 3),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(destinationAddress, style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                width: 70,
                                height: 50,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(Dimens.large)),
                                  color: Colors.black,
                                ),
                                duration: const Duration(seconds: 3),
                                child: Center(child: Text(distance, style: GoogleFonts.nunito(color: Colors.deepOrange, fontWeight: FontWeight.bold))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // بعد از نهایی شدن مقصد، درخواست راننده فعال می‌شود
                          if (isDestinationFinalized) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Requesting a driver...')),
                            );
                          }
                        },
                        child: const Text('Request Driver'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          MyBackButton(
            onPressed: () {
              handleBackButton();
            },
          ),
        ],
      ),
    );
  }

  void handleBackButton() {
    if (destinationPoint != null && isDestinationFinalized) {
      setState(() {
        mapController.removeMarker(destinationPoint!);
        destinationPoint = null;
        isDestinationFinalized = false;
      });
    } else if (originPoint != null && destinationPoint == null) {
      setState(() {
        mapController.removeMarker(originPoint!);
        originPoint = null;
        isSelectingOrigin = true;
      });
    }
  }
}
