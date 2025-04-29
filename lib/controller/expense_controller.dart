import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/db_helper.dart';

class ExpenseController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  RxString selectedCategory = ''.obs;
  var expenses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  void loadExpenses() async {
    final data = await DBHelper.getExpenses();
    expenses.value = data;
  }

  Future<void> addExpense(Map<String, dynamic> newExpense) async {
    await DBHelper.insertExpense(newExpense);
    loadExpenses(); // refresh list after inserting
  }

  Future<void> deleteExpense(int id) async {
    await DBHelper.deleteExpense(id);
    loadExpenses(); // refresh list after deleting
  }

  // Function to Save Expense
  void saveExpense() async {
    String title = titleController.text.trim();
    String amountText = amountController.text.trim();
    String date = dateController.text.trim();
    String category = selectedCategory.value;

    if (title.isEmpty ||
        amountText.isEmpty ||
        category.isEmpty ||
        date.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      return;
    }

    await DBHelper.insertExpense({
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    });

    Get.snackbar('Success', 'Expense Added Successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);

    titleController.clear();
    amountController.clear();
    dateController.clear();
    selectedCategory.value = '';

    Get.back();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
