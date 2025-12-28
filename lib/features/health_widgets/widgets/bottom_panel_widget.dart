import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  final double widgetHeight;
  const BottomPanel({super.key, required this.widgetHeight});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.15, // Начальная высота как доля от экрана (minHeight / widgetHeight)
      minChildSize: 0.15,     // Минимальная высота (нельзя свайпнуть ниже)
      maxChildSize: 0.5,                    // Максимальная высота — половина экрана
      expand: true,                         // Позволяет полностью расширяться
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3))],
          ),
          child: SingleChildScrollView(  // Для скролла контента внутри панели
            controller: scrollController, // Обязательно передайте контроллер для интеграции со свайпом
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 180, 20, 20), // Ваш padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Здесь добавьте ваш контент, который будет скроллиться
                  // Пример:
                  Text('Заголовок панели', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true, // Чтобы ListView не занимал бесконечное пространство
                    physics: const NeverScrollableScrollPhysics(), // Отключаем внутренний скролл, если нужно
                    itemCount: 20, // Пример: много элементов для демонстрации скролла
                    itemBuilder: (context, index) => ListTile(title: Text('Элемент $index')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}