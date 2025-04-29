import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/expense_controller.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ExpenseController controller =
      Get.find(); // controller already injected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.expenses.isEmpty) {
          return const Center(child: Text('No Expenses Yet'));
        }
        return ListView.builder(
          itemCount: controller.expenses.length,
          itemBuilder: (context, index) {
            final expense = controller.expenses[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Expense'),
                      content: const Text(
                          'Are you sure you want to delete this expense?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await controller.deleteExpense(expense['id']);
                            Get.back(); // Close dialog
                            Get.snackbar(
                                'Deleted', 'Expense deleted successfully',
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP);
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    expense['category'][0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(expense['title']),
                subtitle: Text('${expense['category']} • ${expense['date']}'),
                trailing: Text(
                  '₹${expense['amount']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddExpenseScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
