import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:contacts_app/repositories/water_drink/water_tracker_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/widgets.dart';

class PlantDetailPage extends StatefulWidget {
  final int startIndexWidget;
  PlantDetailPage({super.key, required this.startIndexWidget});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late int _indexWidget;

  @override
  void initState() {
    super.initState();
    _indexWidget = widget.startIndexWidget;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // полностью убирает затемнение
          statusBarIconBrightness: Brightness.dark, // иконки под темный/светлый фон
          statusBarBrightness: Brightness.light,
        ),
       child:
       Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<HealthWidgetsBloc, HealthWidgetsState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  const Color(0xFFFFF8F0),
                  const Color(0xFFE8F6F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            ),
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (state is HealthWidgetsLoaded) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    final widgetWidth = w * 0.71;
                    final widgetHeight = h * 0.65;
                    final Map<int, Widget Function()> _widgets = {
                      0: () => NutritionStatsWidget(
                        calories: 0.1,
                        protein: 0.35,
                        fat: 0.70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            topLeft: Radius.circular(24),
                            bottomRight: Radius.zero,
                            bottomLeft: Radius.circular(24),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/icons/i3.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment(0, 0.8),
                          ),
                        ),
                      ),
                      1: () => WaterTrackerWidget(
                        preview: false,
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), topLeft: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        currentWater: state.waterDrunk,
                      )
                    };

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                            top: 0,
                            right: 0,
                            child: DetailWidget(widgetWidth: widgetWidth, widgetHeight: widgetHeight, widget: _widgets[_indexWidget]!, indexWidget: _indexWidget,)
                        ),

                        // Левая колонка кнопок — внутри SafeArea (чтобы не налезали на вырез)
                        Positioned(
                          top: h * 0.14, // относительная позиция — лучше, чем магические numbers
                          left: 16,
                          child: Column(
                            children: [
                              SideIconButton(icon: Icons.wb_sunny, tooltip: 'Light', color: Colors.yellow,),
                              SizedBox(height: h * 0.04),
                              SideIconButton(icon: Icons.opacity, tooltip: 'Water', color: Colors.blueAccent, onPressed: () {
                                setState(() {
                                  _indexWidget = 1;
                                });
                              },),
                              SizedBox(height: h * 0.04),
                              SideIconButton(icon: Icons.food_bank, tooltip: 'Air', color: Colors.brown, onPressed: () {
                                setState(() {
                                  _indexWidget = 0;
                                });
                              },),
                              SizedBox(height: h * 0.04),
                              SideIconButton(icon: Icons.local_florist, tooltip: 'Flower', color: Colors.lightGreen,),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 12,
                          left: 16,
                          child: BackButtonCustom(returnIndex:_indexWidget,),
                        ),

                        // Нижняя белая панель — защита от overflow: используем maxHeight
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                            child: SizedBox(
                              height: constraints.maxHeight, // Явно ограничиваем высоту
                              // child: BottomPanel(widgetHeight: constraints.maxHeight),
                                child: DrinksBottomPanel(
                                  drinksStream: GetIt.I<WaterTrackerRepository>().watchDayDrinks(DateTime.now()), // передайте вашу дату
                                  onDelete: (id) => GetIt.I<WaterTrackerRepository>().deleteWater(id),
                                  onUpdate: (d) => GetIt.I<WaterTrackerRepository>().updateDrink(d),
                                ),
                            ),
                        )
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                },
              ),
            ),
          );
        },
      ),
    )
    );
  }
}








