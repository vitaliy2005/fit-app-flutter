import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterTrackerWidget extends StatefulWidget {
  final bool preview;
  final BoxDecoration decoration;
  final int currentWater;
  const WaterTrackerWidget({super.key, required this.preview, required this.decoration, required this.currentWater});


  @override
  State<WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<WaterTrackerWidget>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController(text: '250');
  final int _target = 2500;
  bool _showContent = false;

  late AnimationController _aniController;
  late Animation<double> _pulseAnim;

  late AnimationController _contentController;
  late Animation<double> _tfOpacity;
  late Animation<Offset> _tfOffset;
  late Animation<double> _btnOpacity;
  late Animation<Offset> _btnOffset;
  late Animation<double> _hintOpacity;
  late Animation<Offset> _hintOffset;
  late Animation<double> _tfScale;
  late Animation<double> _btnScale;
  late AnimationController _progressController;
  late Animation<double> _progressAnim;
  late Animation<double> __cupsSpacingAnim;

  static const double _cupsSpacingPreview = 28.0; // расстояние в preview (дальше)
  static const double _cupsSpacingDetail = 0;


  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _aniController, curve: Curves.easeOut),
    );
    _aniController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _aniController.reverse();
      }
    });

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );


    _tfOpacity = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _tfOffset = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _tfScale = Tween<double>(begin: 0.985, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _btnOpacity = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    );
    _btnOffset = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );
    _btnScale = Tween<double>(begin: 0.99, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );

    _hintOpacity = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    _hintOffset = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: const Interval(0.45, 1.0, curve: Curves.easeOut)),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnim = Tween<double>(begin: 0, end: widget.currentWater / _target)
        .animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    __cupsSpacingAnim = Tween<double>(begin: _cupsSpacingPreview, end: _cupsSpacingDetail).animate(CurvedAnimation(parent: _contentController, curve: Curves.easeOut));

    if (!widget.preview) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() {
          final route = ModalRoute.of(context);
          if (route == null || !route.isCurrent) {
            // вероятно, это shuttle/временный экземпляр — пропускаем включение контента
            debugPrint('Probably shuttle — skipping _showContent');
            return;
          }
          if (mounted) {
            setState(() => _showContent = true);
            _contentController.forward();
            _progressController.forward();
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() {
          final route = ModalRoute.of(context);
          if (route == null || !route.isCurrent) {
            // вероятно, это shuttle/временный экземпляр — пропускаем включение контента
            debugPrint('Probably shuttle — skipping _showContent');
            return;
          }
          if (mounted) {
            _progressController.forward();
          }
        });
      });

    }
  }


  @override
  void dispose() {
    if (_aniController.isAnimating) _aniController.stop(canceled: true);
    if (_contentController.isAnimating) _contentController.stop(canceled: true);

    _aniController.dispose();
    _contentController.dispose();
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _addWater() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      _showMessage('Введите количество воды');
      return;
    }

    // Allow simple integers only (ml)
    final value = int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (value == null || value <= 0) {
      _showMessage('Введите корректное количество (целое число в мл)');
      return;
    }

    context.read<HealthWidgetsBloc>().add(HealthWidgetsDrinkWaterEvent(ml: int.parse(text)));
    print(int.parse(text));
    _aniController.forward(from: 0.0);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WaterTrackerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentWater != widget.currentWater) {
      _progressController.reset();
      _progressAnim = Tween<double>(
        begin: (oldWidget.currentWater / _target).clamp(0.0, 1.0),
        end: (widget.currentWater / _target).clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOut,
      ));
      _progressController.forward();
    }

    if (oldWidget.preview != widget.preview) {
      if (!widget.preview) {
        // переходим в детальный режим — показываем контент и анимируем
        if (mounted) {
          setState(() => _showContent = true);
          _contentController.forward();
        }
      } else {
        // переходим в preview — убираем контент (сначала анимируем назад, затем скрываем)
        _contentController.reverse().whenComplete(() {
          if (mounted) setState(() => _showContent = false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(18.0),
          decoration: widget.decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/капля.png', width: 40, height: 40,),
                  const SizedBox(width: 5),
                  const Text(
                    'Water tracker',
                    style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.currentWater.toString().replaceAllMapped(
                        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (
                        m) => '${m[1]},')} ml',
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A40)),
                  ),
                  SizedBox(width: 3),
                  Text(
                    '/${_target.toString().replaceAllMapped(
                        RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (
                        m) => '${m[1]},')} ml',
                    style: const TextStyle(fontSize: 20,
                        color: Color(0xFF5E6A73)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // progress bar with rounded look
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        minHeight: 18,
                        value: _progressAnim.value,
                        backgroundColor: const Color(0xFFEAF4FF),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E9BFF)),
                      ),
                    );
                  },
                )
              ),

              AnimatedBuilder(
                animation: __cupsSpacingAnim,
                builder: (context, child) {
                  return SizedBox(height: __cupsSpacingAnim.value,);
                },
              ),
              // glasses icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  // calculate fill for each cup assuming 250ml per cup
                  final bool cupFill = widget.currentWater >=
                      (_target ~/ 4) * (index + 1);

                  return Expanded(
                    child: _CupWidget(isfill: cupFill),
                  );
                }),
              ),

              _showContent
                  ? Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeTransition(
                      opacity: _tfOpacity,
                      child: SlideTransition(
                        position: _tfOffset,
                        child: ScaleTransition(
                          scale: _tfScale,
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              hintText: 'Количество',
                              suffixText: 'мл',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF4FBFF),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Button: тоже с анимацией
                    FadeTransition(
                      opacity: _btnOpacity,
                      child: SlideTransition(
                        position: _btnOffset,
                        child: ScaleTransition(
                          scale: _btnScale,
                          child: ElevatedButton(
                            onPressed: _addWater,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 18.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFF2E9BFF),
                              elevation: 6,
                              shadowColor: const Color(0x1A2E9BFF),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add, size: 20,
                                    color: Colors.black38),
                                SizedBox(width: 6),
                                Text('Добавить воду',
                                    style: TextStyle(color: Colors.black38)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // hint: легкая задержка (stagger)
                    FadeTransition(
                      opacity: _hintOpacity,
                      child: SlideTransition(
                        position: _hintOffset,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0),
                          child: Text(
                            'Подсказка: введите количество в миллилитрах (например, 250).',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 20,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         context.read<HealthWidgetsBloc>().add(HealthWidgetsClearWaterEvent());
                    //       },
                    //       child: Container(
                    //         child: const Icon(
                    //           Icons.refresh,
                    //           color: const Color(0xFF2E9BFF),
                    //           size: 40,
                    //         ),
                    //         height: 60,
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CupWidget extends StatelessWidget {
  final bool isfill;
  const _CupWidget({required this.isfill});

  @override
  Widget build(BuildContext context) {
    // size consistent with card width
    return Container(
      width: 64,
      height: 72,
      padding: const EdgeInsets.all(6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(isfill ? 'assets/icons/стакан.png' :'assets/icons/empty_glass.png', height: isfill ? 64 : 39, width: isfill ? 64 : 41,)
        ],
      ),
    );
  }
}





