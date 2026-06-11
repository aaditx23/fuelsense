import 'package:flutter/material.dart';
import 'package:flutter_template/views/screens/screen02/screen02_provider.dart';
import 'package:provider/provider.dart';

class Screen02 extends StatefulWidget {
  const Screen02({super.key});

  @override
  State<Screen02> createState() => _Screen02State();
}

class _Screen02State extends State<Screen02> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Screen02Provider provider = context.watch<Screen02Provider>();

    void getResult() {
      final int? id = int.tryParse(_inputController.text);
      if (id != null) {
        provider.getTodo(id);
      }
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 12.0),
            Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    onChanged: (value) {},
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _inputController.clear();
                        },
                        icon: Icon(Icons.backspace),
                      ),
                      isDense: true,
                      label: Text("Input Data"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                IconButton(
                  onPressed: _inputController.text.isEmpty ? null : getResult,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Card(
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Text("userID: ${provider.todo?.userId}"),
                        Text("ID: ${provider.todo?.id}"),
                        Text("Title: ${provider.todo?.title}"),
                        Text("Completed?: ${provider.todo?.completed}"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
