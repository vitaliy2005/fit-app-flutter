// drinks_bottom_panel.dart
import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:contacts_app/repositories/water_drink/water_drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _kMinSheetSize = 0.15;
const double _kInitialSheetSize = 0.20;
const double _kMaxSheetSize = 0.6;

const Color _kPrimaryBlue = Color(0xFF2E9BFF);
const Color _kLightBlueBg = Color(0xFFEAF4FF);

class DrinksBottomPanel extends StatefulWidget {
  final Stream<List<WaterDrink>> drinksStream;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(WaterDrink drink) onUpdate;
  final String? dayLabel;

  const DrinksBottomPanel({
    super.key,
    required this.drinksStream,
    required this.onDelete,
    required this.onUpdate,
    this.dayLabel,
  });

  @override
  State<DrinksBottomPanel> createState() => _DrinksBottomPanelState();
}

class _DrinksBottomPanelState extends State<DrinksBottomPanel> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  bool get _isExpanded =>
      _sheetController.size > (_kMinSheetSize + (_kMaxSheetSize - _kMinSheetSize) / 2);

  Future<void> _expand() async {
    await _sheetController.animateTo(_kMaxSheetSize,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future<void> _collapse() async {
    await _sheetController.animateTo(_kMinSheetSize,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> _toggle() async {
    if (_isExpanded) {
      await _collapse();
    } else {
      await _expand();
    }
  }

  String _formatTime(BuildContext ctx, DateTime dt) {
    try {
      return TimeOfDay.fromDateTime(dt).format(ctx);
    } catch (_) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDateShort(DateTime dt) => '${dt.day}.${dt.month}';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _kInitialSheetSize,
      minChildSize: _kMinSheetSize,
      maxChildSize: _kMaxSheetSize,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3))],
          ),
          child: Column(
            children: [
              // увеличенная зона хендла — ловит жесты по всей ширине
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                // при движении пальца двигаем sheet пропорционально дельте
                onVerticalDragUpdate: (details) {
                  final screenH = MediaQuery.of(context).size.height;
                  if (screenH <= 0) return;
                  final deltaFraction = details.delta.dy / screenH; // положительное — вниз, отрицательное — вверх
                  final newSize = (_sheetController.size - deltaFraction).clamp(_kMinSheetSize, _kMaxSheetSize);
                  _sheetController.jumpTo(newSize); // сразу двигаем sheet за пальцем
                },
                onVerticalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0.0;
                  const velThreshold = 600.0;
                  if (velocity < -velThreshold) {
                    _sheetController.animateTo(_kMaxSheetSize, duration: Duration(milliseconds: 260), curve: Curves.easeOut);
                    return;
                  }
                  if (velocity > velThreshold) {
                    _sheetController.animateTo(_kMinSheetSize, duration: Duration(milliseconds: 220), curve: Curves.easeOut);
                    return;
                  }
                  // snap по позиции
                  final mid = (_kMinSheetSize + _kMaxSheetSize) / 2;
                  if (_sheetController.size >= mid) {
                    _sheetController.animateTo(_kMaxSheetSize, duration: Duration(milliseconds: 260), curve: Curves.easeOut);
                  } else {
                    _sheetController.animateTo(_kMinSheetSize, duration: Duration(milliseconds: 220), curve: Curves.easeOut);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14), // делаем хит-зону выше
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),


              // Основной StreamBuilder — одна подписка
              Expanded(
                child: StreamBuilder<List<WaterDrink>>(
                  stream: widget.drinksStream,
                  builder: (context, snapshot) {
                    final items = snapshot.data ?? [];
                    final total = items.fold<int>(0, (s, e) => s + e.amount);

                    return Column(
                      children: [
                        // Заголовок (в ряд с total)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Записи воды',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 2),
                                    if (widget.dayLabel != null)
                                      Text(widget.dayLabel!, style: TextStyle(color: Colors.grey[600], fontSize: 13))
                                    else if (items.isNotEmpty)
                                      Text(_formatDateShort(items.first.time), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: _kLightBlueBg, borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.opacity, color: _kPrimaryBlue, size: 18),
                                    const SizedBox(width: 8),
                                    Text('$total ml', style: const TextStyle(fontWeight: FontWeight.w700, color: _kPrimaryBlue)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Список — использует scrollController, чтобы взаимодействие с Draggable было корректным
                        Expanded(
                          child: items.isEmpty
                              ? SingleChildScrollView(
                            controller: scrollController,
                            child: SizedBox(
                              height: 220,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_drink_outlined, size: 56, color: Colors.grey[300]),
                                    const SizedBox(height: 12),
                                    Text('Записей нет', style: TextStyle(color: Colors.grey[600])),
                                    const SizedBox(height: 6),
                                    Text('Добавляйте воду из виджета выше', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (ctx, idx) {
                              final drink = items[idx];
                              return _buildDismissibleTile(ctx, drink);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDismissibleTile(BuildContext ctx, WaterDrink drink) {
    return Dismissible(
      key: ValueKey(drink.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        final res = await showDialog<bool>(
          context: ctx,
          builder: (c) => AlertDialog(
            title: const Text('Удалить запись?'),
            content: const Text('Вы уверены, что хотите удалить эту запись воды?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Отмена')),
              TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Удалить')),
            ],
          ),
        );
        if (res == true) {
          await widget.onDelete(drink.id);
          context.read<HealthWidgetsBloc>().add(HealthWidgetsReadEvent());
        }
        return res == true;
      },
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openEditSheet(ctx, drink),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: _kLightBlueBg, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text('${drink.amount}', style: const TextStyle(fontWeight: FontWeight.w800, color: _kPrimaryBlue)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_formatTime(ctx, drink.time), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      if (drink.note != null && drink.note!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(drink.note!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await _openEditSheet(ctx, drink);
                    } else if (value == 'delete') {
                      final confirmed = await showDialog<bool>(
                        context: ctx,
                        builder: (c) => AlertDialog(
                          title: const Text('Удалить запись?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Отмена')),
                            TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Удалить')),
                          ],
                        ),
                      );
                      if (confirmed == true)
                        {
                          await widget.onDelete(drink.id);
                          context.read<HealthWidgetsBloc>().add(HealthWidgetsReadEvent());
                        }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                    PopupMenuItem(value: 'delete', child: Text('Удалить')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditSheet(BuildContext ctx, WaterDrink drink) async {
    DateTime pickedTime = drink.time;
    final mlController = TextEditingController(text: drink.amount.toString());
    final noteController = TextEditingController(text: drink.note ?? '');

    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Редактировать запись', style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  TextField(
                    controller: mlController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Количество (мл)',
                      suffixText: 'мл',
                      filled: true,
                      fillColor: const Color(0xFFF4FBFF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'Заметка (необязательно)',
                      filled: true,
                      fillColor: const Color(0xFFF4FBFF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Text('Время: ', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(context: sheetCtx, initialTime: TimeOfDay.fromDateTime(pickedTime));
                          if (t != null) {
                            pickedTime = DateTime(pickedTime.year, pickedTime.month, pickedTime.day, t.hour, t.minute);
                            // Notifying the modal to rebuild — this is okay for small modal
                            (sheetCtx as Element).markNeedsBuild();
                          }
                        },
                        child: Text(TimeOfDay.fromDateTime(pickedTime).format(sheetCtx)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final value = int.tryParse(mlController.text.replaceAll(RegExp(r'[^0-9]'), ''));
                            if (value == null || value <= 0) {
                              ScaffoldMessenger.of(sheetCtx).showSnackBar(const SnackBar(content: Text('Введите корректное количество')));
                              return;
                            }

                            // Создадим обновлённый объект; обратите внимание:
                            // ваш repo.updateDrink уже пересчитает dayKey из time (как в примере в начале)
                            final updated = WaterDrink()
                              ..id = drink.id
                              ..time = pickedTime
                              ..amount = value
                              ..note = noteController.text
                              ..dayKey = drink.dayKey;

                            await widget.onUpdate(updated);
                            context.read<HealthWidgetsBloc>().add(HealthWidgetsReadEvent());


                            if (Navigator.canPop(sheetCtx)) Navigator.of(sheetCtx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // не забываем очистить контроллеры (они локальные в методе, GC заберёт когда выйдет)
  }
}
