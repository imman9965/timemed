import 'package:flutter/material.dart';

class ClinicalFilterPage extends StatefulWidget {
  const ClinicalFilterPage({super.key});

  @override
  State<ClinicalFilterPage> createState() => _ClinicalFilterPageState();
}

class _ClinicalFilterPageState extends State<ClinicalFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Clinical Filter")));
  }
}
