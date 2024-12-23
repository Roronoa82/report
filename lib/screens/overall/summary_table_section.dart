// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'bar_chart.dart';
import 'average_sale_perticket.dart';
import 'discounts.dart';
import 'payments_table.dart';
import 'sales_by_order_type.dart';
import 'sales_table.dart';
import 'summary_screen.dart';

final logger = Logger();

class SummaryTableSection extends StatelessWidget {
  final dynamic getDate;

  SummaryTableSection({required this.getDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(height: 300, child: LineChartSample()),
        SizedBox(height: 16),
        Container(
          child: SalesTable(
            key: ValueKey(getDate),
            selectDate: getDate,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 400,
          child: PaymentsTable(
            key: ValueKey(getDate),
            selectDate: getDate,
          ),
        ),
        SizedBox(height: 16),
        Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: SummaryScreen(
              showDepositsOnly: 1,
              key: ValueKey(getDate),
              selectDate: getDate,
            )
            //  DepositsTable(
            //   key: ValueKey(getDate),
            //   selectDate: getDate,
            // ),
            ),
        SizedBox(height: 16),
        Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: SummaryScreen(
              showDepositsOnly: 2,
              key: ValueKey(getDate),
              selectDate: getDate,
            )),
        SizedBox(height: 16),
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SummaryScreen(
              showDepositsOnly: 3,
              key: ValueKey(getDate),
              selectDate: getDate,
            )),
        SizedBox(height: 16),
        Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SummaryScreen(
              showDepositsOnly: 4,
              key: ValueKey(getDate),
              selectDate: getDate,
            )),
        SizedBox(height: 16),
        Container(
          child: Center(
            child: DiscountsTable(
              key: ValueKey(getDate),
              selectDate: getDate,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          child: SalesByOrderTypeTable(
            key: ValueKey(getDate),
            selectDate: getDate,
          ),
        ),
        SizedBox(height: 16),
        Container(
          child: Center(
            child: AverageSalePerTicketTable(
              key: ValueKey(getDate),
              selectDate: getDate,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SummaryScreen(
              showDepositsOnly: 5,
              key: ValueKey(getDate),
              selectDate: getDate,
            )),
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SummaryScreen(
              showDepositsOnly: 6,
              key: ValueKey(getDate),
              selectDate: getDate,
            )),
      ],
    );
  }
}
