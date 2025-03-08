import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _type = TransactionType.expense;
  String _category = 'Food';
  DateTime _selectedDate = DateTime.now();
  
  final List<String> _incomeCategories = [
    'Salary', 'Freelance', 'Investments', 'Gifts', 'Other'
  ];
  
  final List<String> _expenseCategories = [
    'Food', 'Transportation', 'Housing', 'Entertainment', 
    'Shopping', 'Utilities', 'Health', 'Education', 'Other'
  ];
  
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      
      // Parse amount safely
      double amount;
      try {
        amount = double.parse(_amountController.text);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }
      
      provider.addTransaction(
        _titleController.text,
        amount,
        _selectedDate,
        _type,
        _category,
        _noteController.text.isEmpty ? null : _noteController.text,
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rs{_type == TransactionType.income ? "Income" : "Expense"} added successfully'),
          backgroundColor: _type == TransactionType.income ? AppTheme.incomeColor : AppTheme.expenseColor,
        ),
      );
      
      Navigator.pop(context);
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _type = TransactionType.income;
                              _category = _incomeCategories.first;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
                              color: _type == TransactionType.income
                                  ? AppTheme.incomeColor.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: _type == TransactionType.income
                                      ? AppTheme.incomeColor
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Income',
                                  style: TextStyle(
                                    color: _type == TransactionType.income
                                        ? AppTheme.incomeColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _type = TransactionType.expense;
                              _category = _expenseCategories.first;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
                              color: _type == TransactionType.expense
                                  ? AppTheme.expenseColor.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: _type == TransactionType.expense
                                      ? AppTheme.expenseColor
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Expense',
                                  style: TextStyle(
                                    color: _type == TransactionType.expense
                                        ? AppTheme.expenseColor
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
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _category,
                items: (_type == TransactionType.income
                        ? _incomeCategories
                        : _expenseCategories)
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Note Field
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

