import 'dart:collection';

class CartState {
  static final CartState _instance = CartState._internal();

  factory CartState() => _instance;

  CartState._internal();

  /// Internal structure: [{subcategoryId: "id", tasks: [{taskId: "id", qty: 2, name: "Task", price: 100}]}]
  final List<Map<String, dynamic>> _data = [];

  /// Get quantity of a specific task
  int getQuantity(String subcategoryId, String taskId) {
    for (var subcategory in _data) {
      if (subcategory['subcategoryId'] == subcategoryId) {
        for (var task in subcategory['tasks']) {
          if (task['taskId'] == taskId) {
            return task['qty'];
          }
        }
      }
    }
    return 0;
  }

  /// Get or create the task list under a subcategory
  List<Map<String, dynamic>> _getOrCreateSubcategory(String subcategoryId) {
    for (var subcategory in _data) {
      if (subcategory['subcategoryId'] == subcategoryId) {
        return subcategory['tasks'];
      }
    }
    List<Map<String, dynamic>> newTaskList = [];
    _data.add({'subcategoryId': subcategoryId, 'tasks': newTaskList});
    return newTaskList;
  }

  /// Increment task quantity with optional metadata
  void increment(String subcategoryId, String taskId,
      {String? name, double? price}) {
    List<Map<String, dynamic>> taskList =
        _getOrCreateSubcategory(subcategoryId);

    for (var task in taskList) {
      if (task['taskId'] == taskId) {
        task['qty'] = (task['qty'] ?? 0) + 1;
        return;
      }
    }

    // Add new task with quantity 1
    taskList.add({
      'taskId': taskId,
      'qty': 1,
      'name': name ?? 'Unnamed Task',
      'price': price ?? 0.0,
    });
  }

  /// Decrement task quantity and remove if 0
  void decrement(String subcategoryId, String taskId) {
    List<Map<String, dynamic>> taskList =
        _getOrCreateSubcategory(subcategoryId);

    for (var i = 0; i < taskList.length; i++) {
      var task = taskList[i];
      if (task['taskId'] == taskId) {
        task['qty'] = task['qty'] - 1;
        if (task['qty'] <= 0) {
          taskList.removeAt(i);
        }
        return;
      }
    }
  }

  /// Get full cart data (nested)
  List<Map<String, dynamic>> getJson() => UnmodifiableListView(_data);

  /// Flatten all tasks for cart or order history UI
  List<Map<String, dynamic>> getFlatTaskList() {
    List<Map<String, dynamic>> flatList = [];

    for (var sub in _data) {
      for (var task in sub['tasks']) {
        if (task['qty'] > 0) {
          flatList.add({
            'name': task['name'],
            'price': task['price'],
            'qty': task['qty'],
            'taskID': task['taskId'],
            'subcategoryID': sub['subcategoryId'],
          });
        }
      }
    }

    return flatList;
  }

  /// Clear the cart
  void clearCart() {
    _data.clear();
  }
}
