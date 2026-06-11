import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/views/screens/screen02/screen02_notifier.dart';
import 'package:template_flutter/views/screens/screen02/screen02_state.dart';

class Screen02 extends ConsumerStatefulWidget {
  const Screen02({super.key});

  @override
  ConsumerState<Screen02> createState() => _Screen02State();
}

class _Screen02State extends ConsumerState<Screen02> {
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
    final Screen02State state = ref.watch(screen02Provider);
    void getResult() {
      final int? id = int.tryParse(_inputController.text);
      if (id != null) {
        ref.read(screen02Provider.notifier).getTodo(id);
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
              child: state.isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Text("userID: ${state.todo?.userId}"),
                        Text("ID: ${state.todo?.id}"),
                        Text("Title: ${state.todo?.title}"),
                        Text("Completed?: ${state.todo?.completed}"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
