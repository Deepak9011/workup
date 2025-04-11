import 'dart:collection';

class CartState {
  static final CartState _instance = CartState._internal();

  factory CartState() {
    return _instance;
  }

  CartState._internal();

  /// Stores the counters in the required format
  /// Example: [{subcategoryId: "id", tasks: [{taskId: "id", qty: 2}]}]
  final List<Map<String, dynamic>> _data = [];

  /// Get the quantity of a specific task inside a subcategory
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

  /// Ensure the subcategory exists and return a reference to its task list
  List<Map<String, dynamic>> _getOrCreateSubcategory(String subcategoryId) {
    for (var subcategory in _data) {
      if (subcategory['subcategoryId'] == subcategoryId) {
        return subcategory['tasks'];
      }
    }

    // If subcategory does not exist, create and add it
    List<Map<String, dynamic>> newTaskList = [];
    _data.add({'subcategoryId': subcategoryId, 'tasks': newTaskList});
    return newTaskList;
  }

  /// Increment task quantity inside a subcategory
  void increment(String subcategoryId, String taskId) {
    List<Map<String, dynamic>> taskList = _getOrCreateSubcategory(subcategoryId);

    for (var task in taskList) {
      if (task['taskId'] == taskId) {
        task['qty'] = (task['qty'] ?? 0) + 1;
        return;
      }
    }

    // If task does not exist, add it with quantity 1
    taskList.add({'taskId': taskId, 'qty': 1});
  }

  /// Decrement task quantity inside a subcategory
  void decrement(String subcategoryId, String taskId) {
    List<Map<String, dynamic>> taskList = _getOrCreateSubcategory(subcategoryId);

    for (var task in taskList) {
      if (task['taskId'] == taskId && task['qty'] > 0) {
        task['qty'] -= 1;
        if (task['qty'] == 0) {
          taskList.remove(task); // Remove the task if quantity becomes 0
        }
        return;
      }
    }
  }

  /// Get JSON representation of the stored data
  List<Map<String, dynamic>> getJson() => UnmodifiableListView(_data);
}


