import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/models/transaction.dart';
import 'package:financetracker/providers/transaction_provider.dart';
import 'package:financetracker/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({Key? key, this.transaction}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late TransactionType _type;
  late DateTime _date;
  String _category = 'Food';

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Utilities',
    'Housing',
    'Health',
    'Education',
    'Travel',
    'Salary',
    'Investment',
    'Gift',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _type = widget.transaction!.type;
      _date = widget.transaction!.date;
      _category = widget.transaction!.category;
    } else {
      _type = TransactionType.expense;
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    final transaction = Transaction(
      id: widget.transaction?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _date,
      type: _type,
      category: _category,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (widget.transaction == null) {
      provider.addTransaction(transaction);
    } else {
      provider.updateTransaction(transaction);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Add Transaction'
            : 'Edit Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Type',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _type = TransactionType.expense;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _type == TransactionType.expense
                                      ? Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _type == TransactionType.expense
                                        ? Theme.of(context).colorScheme.error
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: _type == TransactionType.expense
                                          ? Theme.of(context).colorScheme.error
                                          : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Expense',
                                      style: TextStyle(
                                        color: _type == TransactionType.expense
                                            ? Theme.of(context)
                                                .colorScheme
                                                .error
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _type = TransactionType.income;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _type == TransactionType.income
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _type == TransactionType.income
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      color: _type == TransactionType.income
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        color: _type == TransactionType.income
                                            ? Colors.green
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Transaction Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Title',
                        prefixIcon: Icons.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _amountController,
                        labelText: 'Amount',
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          try {
                            double.parse(value);
                          } catch (e) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(_date),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _category,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _category = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _noteController,
                        labelText: 'Note (Optional)',
                        prefixIcon: Icons.note,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(widget.transaction == null
                    ? 'Add Transaction'
                    : 'Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
