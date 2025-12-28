import 'package:contacts_app/app/bootstrap.dart';


void main() {
  bootstrap();
}
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const CoffeeFitnessLoginApp());
// }
//
// class CoffeeFitnessLoginApp extends StatelessWidget {
//   const CoffeeFitnessLoginApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const CoffeeFitnessLoginScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class CoffeeFitnessLoginScreen extends StatefulWidget {
//   const CoffeeFitnessLoginScreen({super.key});
//
//   @override
//   State<CoffeeFitnessLoginScreen> createState() =>
//       _CoffeeFitnessLoginScreenState();
// }
//
// class _CoffeeFitnessLoginScreenState extends State<CoffeeFitnessLoginScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _glassController;
//   late AnimationController _staggerController;
//   late AnimationController _floatController;
//
//   late Animation<double> _opacityAnim;
//   late Animation<double> _offsetAnim;
//   late Animation<double> _floatAnim;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Анимация появления контейнера
//     _glassController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _opacityAnim = CurvedAnimation(
//       parent: _glassController,
//       curve: Curves.easeOut,
//     );
//
//     _offsetAnim = Tween<double>(begin: 80, end: 0).animate(
//       CurvedAnimation(parent: _glassController, curve: Curves.easeOut),
//     );
//
//     // Анимация поочерёдного появления элементов
//     _staggerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     // Анимация парения
//     _floatController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat(reverse: true);
//
//     _floatAnim = Tween<double>(begin: 0, end: -10).animate(
//       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
//     );
//
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _glassController.forward().whenComplete(() {
//         _staggerController.forward();
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _glassController.dispose();
//     _staggerController.dispose();
//     _floatController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final coffeeGradient = const LinearGradient(
//       colors: [
//         Color(0xFF4B2E2B), // тёмный кофе
//         Color(0xFFA67B5B), // латте
//         Color(0xFFD7B899), // капучино
//       ],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );
//
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: coffeeGradient,
//         ),
//         child: Center(
//           child: AnimatedBuilder(
//             animation: Listenable.merge([_glassController, _floatController]),
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _offsetAnim.value + _floatAnim.value),
//                 child: FadeTransition(
//                   opacity: _opacityAnim,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(
//                         sigmaX: 20 * _opacityAnim.value,
//                         sigmaY: 20 * _opacityAnim.value,
//                       ),
//                       child: Container(
//                         width: 340,
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha:0.15),
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: Colors.white.withValues(alpha:0.2),
//                           ),
//                         ),
//                         child: _buildLoginContent(),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginContent() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Icon(Icons.fitness_center, color: Colors.white, size: 48),
//         const SizedBox(height: 8),
//         const Text(
//           "Coffee & Workout",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//         const SizedBox(height: 24),
//         _staggerItem(
//           index: 0,
//           child: _inputField(Icons.email, "Email"),
//         ),
//         const SizedBox(height: 16),
//         _staggerItem(
//           index: 1,
//           child: _inputField(Icons.lock, "Password", obscure: true),
//         ),
//         const SizedBox(height: 24),
//         _staggerItem(
//           index: 2,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4B2E2B),
//               padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             onPressed: () {},
//             child: const Text(
//               "Login",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _inputField(IconData icon, String hint, {bool obscure = false}) {
//     return TextField(
//       obscureText: obscure,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white70),
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.white54),
//         filled: true,
//         fillColor: Colors.white.withValues(alpha: 0.1),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
//
//   Widget _staggerItem({required int index, required Widget child}) {
//     final delay = index * 200;
//     return AnimatedBuilder(
//       animation: _staggerController,
//       builder: (context, _) {
//         final progress = _staggerController.value;
//         final itemProgress = (progress - (delay / 1200)).clamp(0.0, 1.0);
//         final opacity = Curves.easeOut.transform(itemProgress);
//         final offset = (1 - opacity) * 20;
//         return Opacity(
//           opacity: opacity,
//           child: Transform.translate(
//             offset: Offset(0, offset),
//             child: child,
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';
//
// class RunnerBackground extends StatelessWidget {
//   const RunnerBackground({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           SafeArea(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   const Text(
//                     "🏃‍♂️ Мой фитнес-трекер",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Беги вместе с нами!",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   Expanded(
//                     child: ModelViewer(
//                       src: 'assets/models/runner.glb',
//                       autoPlay: true,
//                       cameraControls: true,
//                       disableZoom: true,
//                       backgroundColor: Colors.transparent,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: RunnerBackground(),
//   ));
// }


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Plant Card',
//       theme: ThemeData(primarySwatch: Colors.teal),
//       home: const PlantDetailPage(),
//     );
//   }
// }
//
// class PlantDetailPage extends StatefulWidget {
//   const PlantDetailPage({super.key});
//
//   @override
//   State<PlantDetailPage> createState() => _PlantDetailPageState();
// }
//
// class _PlantDetailPageState extends State<PlantDetailPage> {
//   final ImageProvider _plantImage = const AssetImage('assets/icons/TEST.jpeg');
//   bool _didPrecache = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_didPrecache) {
//       precacheImage(_plantImage, context);
//       _didPrecache = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorPrimary = Theme.of(context).colorScheme.primary;
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF5F0),
//       // Если хотите, чтобы тело заходило под статус-бар:
//       extendBodyBehindAppBar: true,
//       body: SafeArea(
//         bottom: false,
//         // SafeArea для базовой защиты; внутри используем LayoutBuilder
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final w = constraints.maxWidth;
//             final h = constraints.maxHeight;
//             final imageWidth = w * 0.70;
//             final imageHeight = h * 0.65;
//
//             return Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Правая карточка с изображением (входит под статус-бар)
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     width: imageWidth,
//                     height: imageHeight,
//                     // margin: const EdgeInsets.only(right: 12),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(32),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black26, blurRadius: 22, offset: Offset(0, 12)),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.only(topRight: Radius.zero, topLeft: Radius.circular(32), bottomRight: Radius.zero, bottomLeft: Radius.circular(32)),
//                       child: Image(
//                         image: _plantImage,
//                         fit: BoxFit.cover,
//                         width: imageWidth,
//                         height: imageHeight,
//                         // семантика для accessibility
//                         semanticLabel: 'Plant picture',
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Левая колонка кнопок — внутри SafeArea (чтобы не налезали на вырез)
//                 Positioned(
//                   top: h * 0.14, // относительная позиция — лучше, чем магические numbers
//                   left: 16,
//                   child: Column(
//                     children: [
//                       _SideIconButton(icon: Icons.wb_sunny, tooltip: 'Light'),
//                       SizedBox(height: h * 0.04),
//                       _SideIconButton(icon: Icons.opacity, tooltip: 'Water'),
//                       SizedBox(height: h * 0.04),
//                       _SideIconButton(icon: Icons.air, tooltip: 'Air'),
//                       SizedBox(height: h * 0.04),
//                       _SideIconButton(icon: Icons.local_florist, tooltip: 'Flower'),
//                     ],
//                   ),
//                 ),
//
//                 // Back button — используем SafeArea + Material для ripple
//                 Positioned(
//                   top: 12,
//                   left: 16,
//                   child: Material(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     elevation: 4,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: () => Navigator.of(context).maybePop(),
//                       child: const SizedBox(
//                         width: 58,
//                         height: 58,
//                         child: Icon(Icons.arrow_back, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Нижняя белая панель — защита от overflow: используем maxHeight
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       // гарантия, что панель не займет больше экрана
//                       maxHeight: h * 0.45,
//                       minHeight: 150,
//                     ),
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//                         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3))],
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const _TitleBlock(),
//                               Text(
//                                 '\$440',
//                                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorPrimary),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {},
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: colorPrimary,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                                     padding: const EdgeInsets.symmetric(vertical: 14),
//                                   ),
//                                   child: const Text('Buy now'),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: OutlinedButton(
//                                   onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide(color: colorPrimary),
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                                     padding: const EdgeInsets.symmetric(vertical: 14),
//                                   ),
//                                   child: const Text('Description'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _SideIconButton extends StatelessWidget {
//   final IconData icon;
//   final String tooltip;
//   const _SideIconButton({required this.icon, required this.tooltip});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 4,
//       borderRadius: BorderRadius.circular(14),
//       color: Colors.white,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           // обработка
//         },
//         child: SizedBox(
//           width: 64,
//           height: 64,
//           child: Center(
//             child: Tooltip(
//               message: tooltip,
//               child: Icon(icon, color: Colors.teal, size: 30),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _BigSideButton extends StatelessWidget {
//   final IconData icon;
//   const _BigSideButton({required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
//       ),
//       child: Icon(icon, color: Colors.teal, size: 30),
//     );
//   }
// }
//
// class _TitleBlock extends StatelessWidget {
//   const _TitleBlock();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           'Angelica',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 4),
//         Text(
//           'Russia',
//           style: TextStyle(color: Colors.grey),
//         ),
//       ],
//     );
//   }
// }

