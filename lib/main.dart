import 'package:flutter/material.dart';
import 'models/plan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Plans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanManagerScreen(),
    );
  }
}

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  void addPlan(Plan newPlan) {
    setState(() {
      plans.add(newPlan);
    });
  }

  void removePlan(Plan plan) {
    setState(() {
      plans.remove(plan);
    });
  }

  void markAsCompleted(Plan plan) {
    setState(() {
      plan.status = 'completed';
    });
  }

  void openCreatePlanModal() {
    showDialog(
      context: context,
      builder: (context) {
        return CreatePlanModal(
          onSave: (plan) {
            addPlan(plan);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Open the 'Edit Plan' modal
  void openEditPlanModal(Plan plan) {
    showDialog(
      context: context,
      builder: (context) {
        return CreatePlanModal(
          onSave: (editedPlan) {
            setState(() {
              int index = plans.indexOf(plan);
              if (index != -1) {
                plans[index] = editedPlan;
              }
            });
            Navigator.pop(context); // Close modal
          },
          initialPlan: plan,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan Manager"),
      ),
      body: Center(
        child: plans.isEmpty
            ? Text('No plans added yet.')
            : ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return Dismissible(
                    key: Key(plan.name),
                    onDismissed: (direction) {
                      removePlan(plan);
                    },
                    background: Container(color: Colors.red),
                    child: GestureDetector(
                      onLongPress: () {
                        openEditPlanModal(plan);
                      },
                      child: Card(
                        color: plan.status == 'completed' ? Colors.green[100] : Colors.white,
                        child: ListTile(
                          title: Text(plan.name),
                          subtitle: Text(plan.description),
                          trailing: IconButton(
                            icon: Icon(Icons.check_circle),
                            onPressed: () => markAsCompleted(plan),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreatePlanModal,
        child: Icon(Icons.add),
        tooltip: 'Create Plan',
      ),
    );
  }
}

class CreatePlanModal extends StatefulWidget {
  final Function(Plan) onSave;
  final Plan? initialPlan;

  CreatePlanModal({required this.onSave, this.initialPlan});

  @override
  _CreatePlanModalState createState() => _CreatePlanModalState();
}

class _CreatePlanModalState extends State<CreatePlanModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'Low';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      _nameController.text = widget.initialPlan!.name;
      _descriptionController.text = widget.initialPlan!.description;
      _priority = widget.initialPlan!.priority;
      _date = widget.initialPlan!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialPlan == null ? 'Create New Plan' : 'Edit Plan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Plan Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          ListTile(
            title: Text('Priority'),
            trailing: DropdownButton<String>(
              value: _priority,
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final editedPlan = Plan(
                name: _nameController.text,
                description: _descriptionController.text,
                date: _date,
                priority: _priority,
              );
              widget.onSave(editedPlan);
            },
            child: Text(widget.initialPlan == null ? 'Save Plan' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
