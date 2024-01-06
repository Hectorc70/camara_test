// import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:light/light.dart';
// import 'package:timer_count_down/timer_count_down.dart';

// class CamaraPage extends StatefulWidget {
//   const CamaraPage({super.key});

//   @override
//   State<CamaraPage> createState() => _CamaraPageState();
// }

// class _CamaraPageState extends State<CamaraPage> {
//   String luxString = 'Unknown';
//   int luxCurrentValue = 0;
//   Light? _light;
//   XFile? picture;
//   StreamSubscription? _subscription;
//   late final List<CameraDescription>? cameras;
//   CameraController? cameraController;
//   Future initCamera(CameraDescription cameraDescription) async {
// // create a CameraController
//     cameraController =
//         CameraController(cameraDescription, ResolutionPreset.high);
// // Next, initialize the controller. This returns a Future.
//     try {
//       await cameraController!.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       });
//     } on CameraException catch (e) {
//       debugPrint("camera error $e");
//     }
//   }

//   void onData(int luxValue) async {
//     print("Lux value: $luxValue");
//     setState(() {
//       luxString = "$luxValue";
//       luxCurrentValue = luxValue;
//     });
//   }

//   void startListening() {
//     _light = Light();
//     try {
//       _subscription = _light?.lightSensorStream.listen(onData);
//     } on LightException catch (exception) {
//       print(exception);
//     }
//   }

//   void stopListening() {
//     _subscription?.cancel();
//   }

//   Future<void> start() async {
//     cameras = await availableCameras();
//     initCamera(cameras![1]);
//   }

//   Future takePicture() async {
//     if (!cameraController!.value.isInitialized) {
//       return null;
//     }
//     if (cameraController!.value.isTakingPicture) {
//       return null;
//     }
//     try {
//       await cameraController!.setFlashMode(FlashMode.off);
//       XFile shot = await cameraController!.takePicture();
//       setState(() {
//         picture = shot;
//       });
//       print('Camara foto ${shot.path}}');
//     } on CameraException catch (e) {
//       debugPrint('Error occured while taking picture: $e');
//       return null;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     startListening();
//     start();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     cameraController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final heightScreen = MediaQuery.of(context).size.height;
//     final widthScreen = MediaQuery.of(context).size.width;
//     return cameraController != null
//         ? Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.black,
//               centerTitle: true,
//               title: const Text(
//                 'Foto frontal',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22.0,
//                     color: Colors.white),
//               ),
//             ),
//             body: cameraController!.value.isInitialized
//                 ? Stack(
//                     children: [
//                       CameraPreview(cameraController!),
//                       _getOverlay(context: context),
//                       Positioned(
//                           left: 0,
//                           right: 0,
//                           top: heightScreen * .20,
//                           child: const Text(
//                             'Tu rostro debe ir dentro del circulo',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           )),
//                       Positioned(
//                         left: 0,
//                         right: 0,
//                         top: heightScreen * .66,
//                         child: Builder(builder: (_) {
//                           if (picture == null) {
//                             if (luxCurrentValue > 100) {
//                               return Countdown(
//                                 seconds: 3,
//                                 build: (BuildContext context, double time) =>
//                                     Text(
//                                   time.round().toString(),
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: Colors.white),
//                                 ),
//                                 interval: const Duration(milliseconds: 1),
//                                 onFinished: () {
//                                   takePicture();
//                                 },
//                               );
//                             }

//                             return Text(
//                               'Iluminacion $luxString',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(color: Colors.white),
//                             );
//                           }

//                           return const Text(
//                             'FOTO TOMADA',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           );
//                         }),
//                       ),
//                       Positioned(
//                           right: 10,
//                           bottom: 5,
//                           child: Column(
//                             children: [
//                               luxCurrentValue > 100 || picture != null
//                                   ? const Row(
//                                       children: [
//                                         Icon(
//                                           Icons.done,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5.0,
//                                         ),
//                                         Text(
//                                           'Buena iluminación',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   : const SizedBox()
//                             ],
//                           ))
//                     ],
//                   )
//                 : Container(
//                     decoration: const BoxDecoration(color: Colors.black),
//                     child: const Center(
//                         child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ))))
//         : const Scaffold();
//   }

//   Widget _getOverlay({required BuildContext context}) {
//     final heightScreen = MediaQuery.of(context).size.height;
//     final widthScreen = MediaQuery.of(context).size.width;
//     double width = widthScreen * .70;
//     return ColorFiltered(
//       colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcOut),
//       child: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.transparent,
//             ),
//             child: Align(
//               alignment: Alignment.center,
//               child: Container(
//                 height: width,
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors
//                       .black, // Color does not matter but should not be transparent
//                   borderRadius: BorderRadius.circular(width),
//                 ),
//               ),
//             ),
//           ),
//           const Positioned(
//             right: 0,
//             child: Text('.'),
//           ),
//           const Positioned(
//               bottom: -1,
//               child: SizedBox(
//                 child: Text('.'),
//               ))
//         ],
//       ),
//     );
//   }
//   // Widget _getOverlay({required BuildContext context}) {
//   //   final heightScreen = MediaQuery.of(context).size.height;
//   //   final widthScreen = MediaQuery.of(context).size.width;
//   //   return Stack(
//   //     children: [
//   //       // Fondo negro
//   //       Container(
//   //         color: Colors.black,
//   //         child: Opacity(
//   //           opacity: 0.5, // Puedes ajustar la opacidad según tus necesidades
//   //           child: SizedBox.expand(),
//   //         ),
//   //       ),
//   //       // Círculo transparente en el centro
//   //       Center(
//   //         child: ClipOval(
//   //           child: Container(
//   //             height: heightScreen *
//   //                 0.5, // Ajusta el tamaño del círculo según sea necesario
//   //             width: widthScreen * 0.5,
//   //             color: Colors.transparent,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
// }
