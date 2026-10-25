import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => ExpenseItem(expenses[index]),
    );
  }
}

/*

that itembuilder function get called the length pass in itemCount so if 2 2 items rendereded by that function


This is best for imporving performce for longlits that has to be in a scrollbale view by default


Column juts ceates them immediately even if its not display i the curent view of scrollable list so perfomeacne issues 

*/
