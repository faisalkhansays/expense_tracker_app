import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/expense_controller.dart';
import 'home_screen.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});

  final ExpenseController controller = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final RxString selectedCategory = ''.obs;

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

    await controller.addExpense({
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
    Get.offAll(() => HomeScreen());
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      dateController.text = '${pickedDate.toLocal()}'
          .split(' ')[0]; // Format date to 'yyyy-mm-dd'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTap: () => selectDate(context), // Date picker call
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration:
                      const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
              ),
            ),
            Obx(() => DropdownButton<String>(
                  value: selectedCategory.value.isEmpty
                      ? null
                      : selectedCategory.value,
                  hint: const Text('Select Category'),
                  onChanged: (value) {
                    selectedCategory.value = value!;
                  },
                  items: [
                    'Food',
                    'Shopping',
                    'Bills',
                    'Entertainment',
                    'Others'
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveExpense,
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
