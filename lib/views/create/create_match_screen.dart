import 'package:flutter/material.dart';
import 'package:volleyspeech/globals.dart';
import 'package:volleyspeech/models/rate_table.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreen();
}

class _CreateMatchScreen extends State<CreateMatchScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Match'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await globals.database.saveRateTable(RateTable(
                  dbID: null,
                  createdAt: DateTime.now(),
                  name: _titleController.text,),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Create Match'),
            ),
          ),
        ],
      ),
    );
  }
}