import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'เทคโนโลยี';

  final List<String> categories = ['เทคโนโลยี', 'บันเทิง', 'การศึกษา'];

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      Navigator.pop(context, {
        'title': _titleController.text,
        'duration': int.parse(_durationController.text),
        'date': _selectedDate!.toLocal().toString().split(' ')[0],
        'category': _selectedCategory,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มตอนพอดแคสต์')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'ชื่อตอนพอดแคสต์'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกชื่อตอน' : null,
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'ระยะเวลา (นาที)'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกระยะเวลา' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'ยังไม่ได้เลือกวันที่'
                          : 'วันที่เผยแพร่: ${_selectedDate!.toLocal()}'
                              .split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('เลือกวันที่'),
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'หมวดหมู่'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('เพิ่มตอน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
