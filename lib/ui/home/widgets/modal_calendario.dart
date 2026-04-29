import 'dart:ui';

import 'package:climtech/ui/home/view_models/home_viewmodel.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:climtech/utils/icons.dart';
import 'package:climtech/utils/texto_formatado.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ModalCalendario extends StatefulWidget {
  const ModalCalendario({super.key});

  @override
  State<ModalCalendario> createState() => _ModalCalendarioState();
}

class _ModalCalendarioState extends State<ModalCalendario> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<HomeViewmodel>(context);
    final tema = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: tema.onPrimary, // cor de fundo do dialog
        child: TableCalendar(
          locale: 'pt_BR',
          focusedDay: prov.pegarDiaAtual,
          firstDay: DateTime.utc(2026, 01, 01),
          lastDay: DateTime.utc(2026, 12, 31),
          currentDay: prov.pegarDiaAtual,

          // Controla quais dias podem ser selecionados
          selectedDayPredicate: (day) => isSameDay(day, prov.pegarDiaAtual),

          // Só permite selecionar dentro dos 14 dias
          onDaySelected: (selectedDay, focusedDay) {
            final hoje = DateTime.now();
            final inicio = DateTime(hoje.year, hoje.month, hoje.day);
            final fim = inicio.add(const Duration(days: 13));
            final dia = DateTime(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
            );

            final dentroDoIntervalo =
                !dia.isBefore(inicio) && !dia.isAfter(fim);

            if (dentroDoIntervalo) {
              //  prov.carregarLocal(selectedDay)
              prov.carregarLocal(); // chame o método do seu viewmodel que atualiza o dia
              Navigator.of(context).pop();
            }
            // Se estiver fora do intervalo, não faz nada — dia bloqueado
          },
          // Cabeçalho
          headerStyle: _headerStyle(tema),

          // Estilo dos dias da semana (dom, seg, ter...)
          daysOfWeekStyle: _daysOfWeekStyle(tema),

          // Estilo dos dias do calendário
          calendarStyle: _calendarStyle(prov.pegarDiaAtual),

          // Builder customizado para cada célula de dia
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) =>
                _dayCell(day, isToday: false, isSelected: false),
            todayBuilder: (context, day, focusedDay) =>
                _dayCell(day, isToday: true, isSelected: false),
            selectedBuilder: (context, day, focusedDay) =>
                _dayCell(day, isToday: false, isSelected: true),
            outsideBuilder: (context, day, focusedDay) => _dayCell(
              day,
              isToday: false,
              isSelected: false,
              isOutside: true,
            ),
          ),
        ),
      ),
    );
  }

  // ── Célula de cada dia ──────────────────────────────────────────────────────
  Widget _dayCell(
    DateTime day, {
    required bool isToday,
    required bool isSelected,
    bool isOutside = false,
  }) {
    Color background;
    Color textColor;

    // Verifica se o dia está dentro dos 14 dias a partir de hoje (inclusive)
    final hoje = DateTime.now();
    final inicioPeriodo = DateTime(hoje.year, hoje.month, hoje.day);
    final fimPeriodo = inicioPeriodo.add(
      const Duration(days: 13),
    ); // 14 dias contando hoje
    final diaAtual = DateTime(day.year, day.month, day.day);
    final isDentroDosPeriodo =
        !diaAtual.isBefore(inicioPeriodo) && !diaAtual.isAfter(fimPeriodo);

    if (isToday) {
      background = Colors.white;
      textColor = Colors.black;
    } else if (isSelected) {
      background = Colors.blue;
      textColor = Colors.white;
    } else if (isDentroDosPeriodo) {
      background = Colors.red; // cor dos 14 dias a partir de hoje
      textColor = Colors.white; // cor do texto dentro do período
    } else {
      background = const Color(0xFFDDE3EA);
      textColor = isOutside ? Colors.grey : Colors.black;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ── Estilos ─────────────────────────────────────────────────────────────────
  HeaderStyle _headerStyle(ColorScheme tema) {
    return HeaderStyle(
      titleTextFormatter: (date, locale) {
        return formatarMesTexto(date);
      },
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: estiloTexto(16),

      // Ícone de seta esquerda (voltar mês)
      leftChevronIcon: Iconify(AppIcons.setaVoltar, color: tema.onSurface),
      // Ícone de seta direita (avançar mês)
      rightChevronIcon: Iconify(AppIcons.setaAvancar, color: tema.onSurface),
      leftChevronPadding: const EdgeInsets.only(left: 4),
      rightChevronPadding: const EdgeInsets.only(right: 4),
      headerPadding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: tema.onSecondary, // cor de fundo do cabeçalho
      ),
    );
  }

  DaysOfWeekStyle _daysOfWeekStyle(ColorScheme tema) {
    return DaysOfWeekStyle(
      weekdayStyle: estiloTexto(13),
      weekendStyle: estiloTexto(13),
    );
  }

  CalendarStyle _calendarStyle(DateTime hoje) {
    return CalendarStyle(
      // Desativa decorações padrão (usamos o calendarBuilders acima)
      isTodayHighlighted: false,
      defaultDecoration: const BoxDecoration(),
      selectedDecoration: const BoxDecoration(),
      todayDecoration: const BoxDecoration(),
      outsideDecoration: const BoxDecoration(),
      cellMargin: const EdgeInsets.all(4),
    );
  }
}
