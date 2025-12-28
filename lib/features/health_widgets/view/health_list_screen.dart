import 'dart:async';
import 'dart:ui' as ui;
import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:contacts_app/features/health_widgets/widgets/widgets.dart';
import 'package:contacts_app/repositories/user_profile/user_profile.dart';
import 'package:contacts_app/repositories/user_profile/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HealthListScreen extends StatefulWidget {
  const HealthListScreen({super.key});

  @override
  State<HealthListScreen> createState() => _HealthListScreen();
}

class _HealthListScreen extends State<HealthListScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  final double _maxSlide = 280.0;
  final double _slideFactor = 0.92;
  final double _scaleFactor = 0.20;
  final double _borderRadius = 0.0;
  final double _blurSigma = 12.0;
  String? name;
  String? surname;

  StreamSubscription<UserProfile?>? _userProfileSub;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    try {
      final repo = GetIt.I<UserProfileRepository>();
      final isar = repo.isar;
      _userProfileSub = isar.userProfiles
          .watchObject(0, fireImmediately: true)
          .listen((user) {
        if (!mounted) return;
        setState(() {
          name = user?.name ?? '';
          surname = user?.surname ?? '';
        });
      });
    } catch (e) {
      debugPrint('HealthListScreen: failed to get UserProfileRepository: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _userProfileSub?.cancel();
    super.dispose();
  }

  void _toggleDrawer() {
    _controller.isDismissed ? _controller.forward() : _controller.reverse();
  }

  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
        }
        return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF8F0), ui.Color.fromARGB(255, 228, 246, 245)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: GestureDetector(
              onHorizontalDragUpdate: (d) => _controller.value += d.delta.dx / _maxSlide,
              onHorizontalDragEnd: (d) => _controller.value > 0.5 ? _controller.forward() : _controller.reverse(),
              child: Stack(
                children: [
                  // === БОКОВОЕ МЕНЮ ===
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(-_maxSlide + _maxSlide * _controller.value, 0),
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: _maxSlide,
                      child: AppDrawer(
                        name: name ?? '',
                        surname: surname ?? '',
                        onProfileTap: () {
                          Navigator.of(context).pushNamed('/profile');
                        },
                      ),
                    ),
                  ),

                  // === ОСНОВНОЙ КОНТЕНТ ===
                  // Используем AnimatedBuilder для сдвига
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final anim = _controller.value;
                      final translateX = _maxSlide * _slideFactor * anim;

                      return Transform.translate(
                        offset: Offset(translateX, 0),
                        child: Container(
                          width: screenWidth,
                          height: screenHeight,
                          child: Stack(
                            children: [
                              // Градиентный фон
                              Container(
                                width: screenWidth,
                                height: screenHeight,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFF8F0), Color(0xFFE8F6F5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),

                              // Содержимое с блюром
                              Positioned.fill(
                                child: _buildContentWithBlur(),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                ),

                // === APPBAR ===
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final anim = _controller.value;
                    final translateX = _maxSlide * _slideFactor * anim;

                    return Transform.translate(
                      offset: Offset(translateX, 0),
                      child: Container(
                        height: statusBarHeight + kToolbarHeight,
                        color: Colors.transparent,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          foregroundColor: Colors.black87,
                          leading: _controller.isDismissed 
                            ? IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: _toggleDrawer,
                              )
                            : const SizedBox(width: 48),
                        ),
                      ),
                    );
                  },
                ),

                // === ТЁМНАЯ ПОДЛОЖКА ===
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    if (_controller.value == 0) return const SizedBox.shrink();
                    final anim = _controller.value;
                    final translateX = _maxSlide * _slideFactor * anim;

                    return Transform.translate(
                      offset: Offset(translateX, 0),
                      child: GestureDetector(
                        onTap: _toggleDrawer,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          width: screenWidth,
                          height: screenHeight,
                          color: Colors.black.withOpacity(0.45 * anim),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
      
    );
  }

  Widget _buildContentWithBlur() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final anim = _controller.value;
        final scale = 1.0 - _scaleFactor * anim;
        final radius = _borderRadius * anim;
        final blur = _blurSigma * anim;

        return Stack(
          children: [
            // Основной контент
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
                  Expanded(
                    child: BlocConsumer<HealthWidgetsBloc, HealthWidgetsState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is HealthWidgetsLoaded) {
                          return Transform.scale(
                            scale: scale,
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 100),
                                  Carousel(
                                    itemCount: 2,
                                    listWidgets: {
                                      0: () => NutritionStatsWidget(
                                        calories: 0.1,
                                        protein: 0.35,
                                        fat: 0.70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          image: const DecorationImage(
                                            image: AssetImage('assets/icons/i3.png'),
                                            fit: BoxFit.cover,
                                            alignment: Alignment(0, 0.8),
                                          ),
                                        ),
                                      ),
                                      1: () => WaterTrackerWidget(
                                        preview: true,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 8)),
                                          ],
                                        ),
                                        currentWater: state.waterDrunk,
                                      ),
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Блюр поверх контента
            if (anim > 0)
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}