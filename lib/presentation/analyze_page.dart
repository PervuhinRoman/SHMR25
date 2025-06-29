import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/datepicker_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  @override
  Widget build(BuildContext context) {
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();
    return BlocBuilder<DatePickerCubit, DatePickerState>(
      builder: (context, datePickerState) {
        return Scaffold(
          appBar: CustomAppBar(title: "Анализ", bgColor: Colors.white),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Период: начало"),
                    InputChip(
                      label: Text(
                        datePickerState.startDate != null
                            ? DateFormat(
                              'dd.MM.yyyy',
                            ).format(datePickerState.startDate!)
                            : "Выберите дату",
                        textAlign: TextAlign.end,
                      ),
                      backgroundColor: CustomAppTheme.figmaMainColor,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      onPressed: () async {
                        final DateTime? resultStartDate = await showDatePicker(
                          context: context,
                          initialDate:
                              datePickerState.startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          helpText: 'Выберите дату начала',
                          cancelText: 'Отмена',
                          confirmText: 'ОК',
                        );
                        if (resultStartDate != null) {
                          datePickerCubit.setStartDate(resultStartDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Период: начало"),
                    InputChip(
                      label: Text(
                        datePickerState.endDate != null
                            ? DateFormat(
                          'dd.MM.yyyy',
                        ).format(datePickerState.endDate!)
                            : "Выберите дату",
                        textAlign: TextAlign.end,
                      ),
                      backgroundColor: CustomAppTheme.figmaMainColor,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      onPressed: () async {
                        final DateTime? resultEndDate = await showDatePicker(
                          context: context,
                          initialDate:
                          datePickerState.startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          helpText: 'Выберите дату конца',
                          cancelText: 'Отмена',
                          confirmText: 'ОК',
                        );
                        if (resultEndDate != null) {
                          datePickerCubit.setEndDate(resultEndDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16,
                  top: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Сумма"), Text("100 000 ₽")],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              Spacer(),
              Expanded(child: ListView()),
            ],
          ),
        );
      },
    );
  }
}
