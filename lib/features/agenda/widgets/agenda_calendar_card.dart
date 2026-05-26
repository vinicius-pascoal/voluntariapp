import 'package:flutter/material.dart';

class AgendaCalendarCard extends StatefulWidget {
  const AgendaCalendarCard({super.key, this.onDateChanged});

  final ValueChanged<DateTime>? onDateChanged;

  @override
  State<AgendaCalendarCard> createState() => _AgendaCalendarCardState();
}

class _AgendaCalendarCardState extends State<AgendaCalendarCard> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _focusedMonth = DateTime(date.year, date.month);
    });

    widget.onDateChanged?.call(_selectedDate);
  }

  static bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static List<DateTime> _buildVisibleDays(DateTime focusedMonth) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final firstGridDay = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return List<DateTime>.generate(42, (index) {
      return firstGridDay.add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 336,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 19, 24, 20),
        child: Column(
          children: [
            _CalendarTopControls(
              focusedMonth: _focusedMonth,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
            ),
            const SizedBox(height: 20),
            const _WeekDaysRow(),
            const SizedBox(height: 14),
            Expanded(
              child: _CalendarDaysGrid(
                focusedMonth: _focusedMonth,
                selectedDate: _selectedDate,
                onDateSelected: _selectDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarTopControls extends StatelessWidget {
  const _CalendarTopControls({
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime focusedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  static const List<String> _monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MonthNavButton(icon: Icons.chevron_left, onPressed: onPreviousMonth),
        const SizedBox(width: 16),
        Expanded(
          child: Center(
            child: Text(
              '${_monthNames[focusedMonth.month - 1]} ${focusedMonth.year}',
              style: const TextStyle(
                color: Color(0xFF303030),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _MonthNavButton(icon: Icons.chevron_right, onPressed: onNextMonth),
      ],
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
        ),
        child: Icon(icon, color: const Color(0xFF1E1E1E), size: 24),
      ),
    );
  }
}

class _WeekDaysRow extends StatelessWidget {
  const _WeekDaysRow();

  @override
  Widget build(BuildContext context) {
    const weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                color: Color(0xFF8A8A8A),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarDaysGrid extends StatelessWidget {
  const _CalendarDaysGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final days = _AgendaCalendarCardState._buildVisibleDays(focusedMonth);
    final today = _AgendaCalendarCardState._dateOnly(DateTime.now());

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 5,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final isCurrentMonth = day.month == focusedMonth.month;
        final isSelected = _AgendaCalendarCardState._isSameDay(
          day,
          selectedDate,
        );
        final isToday = _AgendaCalendarCardState._isSameDay(day, today);

        return InkWell(
          onTap: () => onDateSelected(day),
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFFFA500) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFFFFA500), width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isCurrentMonth
                            ? const Color(0xFF303030)
                            : const Color(0xFFA7A7A7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
