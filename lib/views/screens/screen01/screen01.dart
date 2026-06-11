import 'package:flutter/material.dart';
import 'package:flutter_template/views/screens/screen01/screen01_provider.dart';
import 'package:provider/provider.dart';

class Screen01 extends StatefulWidget {
  const Screen01({super.key});

  @override
  State<Screen01> createState() => _Screen01State();
}

class _Screen01State extends State<Screen01> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Screen01Provider>().getAllNames();
    });
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
    final provider = context.watch<Screen01Provider>();

    void saveText() {
      provider.insertName(_inputController.text);
    }

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/screen02");
        },
        child: Icon(Icons.navigate_next_sharp),
      ),
      body: Column(
        children: [
          SizedBox(height: 12.0),
          Row(
            children: [
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onChanged: (value) {},
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
                onPressed: _inputController.text.isEmpty ? null : saveText,
                icon: Icon(Icons.send),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Text("Floor Databse"),
          Expanded(
            child: ListView.builder(
              itemCount: provider.namesList.length,
              itemBuilder: (context, index) {
                final name = provider.namesList[index];
                final id = name.id ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 6.0,
                    bottom: 6.0,
                  ),
                  child: Card(
                    key: Key(id.toString()),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("${name.id}. ${name.name}"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
