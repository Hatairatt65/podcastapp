import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map<String, dynamic>? episode;

  const AddPage({super.key, this.episode});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'เทคโนโลยี';

  final List<String> categories = [
    'เทคโนโลยี',
    'บันเทิง',
    'การศึกษา',
    'สุขภาพ',
    'ข่าวสาร',
    'แรงบันดาลใจ',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.episode != null) {
      _titleController.text = widget.episode!['title'];
      _durationController.text = widget.episode!['duration'].toString();
      _selectedDate = DateTime.parse(widget.episode!['date']);
      _selectedCategory = widget.episode!['category'];
    }
  }

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
      appBar: AppBar(
        title: Text(widget.episode == null ? 'เพิ่มตอนพอดแคสต์' : 'แก้ไขตอนพอดแคสต์'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รายละเอียดตอนพอดแคสต์',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อตอนพอดแคสต์',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.album, color: Colors.purple),
                      ),
                      validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อตอน' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ระยะเวลา (นาที)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.timer, color: Colors.purple),
                      ),
                      validator: (value) => value!.isEmpty ? 'กรุณากรอกระยะเวลา' : null,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'วันที่เผยแพร่',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'เลือกวันที่'
                                  : '${_selectedDate!.toLocal()}'.split(' ')[0],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.purple),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                      decoration: InputDecoration(
                        labelText: 'หมวดหมู่',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.category, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.purple,
                          elevation: 5,
                        ),
                        child: Text(
                          widget.episode == null ? 'เพิ่มตอน' : 'บันทึก',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
