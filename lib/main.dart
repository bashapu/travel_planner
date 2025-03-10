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
                  return ListTile(
                    title: Text(plan.name),
                    subtitle: Text(plan.description),
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

  CreatePlanModal({required this.onSave});

  @override
  _CreatePlanModalState createState() => _CreatePlanModalState();
}

class _CreatePlanModalState extends State<CreatePlanModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'Low';
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Plan'),
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
              final newPlan = Plan(
                name: _nameController.text,
                description: _descriptionController.text,
                date: _date,
                priority: _priority,
              );
              widget.onSave(newPlan);
            },
            child: Text('Save Plan'),
          ),
        ],
      ),
    );
  }
}
