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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan Manager"),
      ),
      body: Center(
        child: Text('You have ${plans.length} plans.'),
      ),
    );
  }
}
