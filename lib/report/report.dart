import 'package:appmangxahoi/apis/report_api.dart';
import 'package:appmangxahoi/entities/report.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  final dynamic content;
  ReportScreen({this.content});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

List<String> _reportReasons = [
  'Bài viết này quá nhạy cảm',
  'Bài viết này ăn cắp bản quyền',
  'Bài viết này bị lỗi ảnh',
  'Cái khác'
];

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  var reportAPI = ReportAPI();
  String _selectedReason = 'Bài viết này quá nhạy cảm';
  bool _isOtherReason = false;

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      var description = _descriptionController.text;
      var reason = _selectedReason;
      var report = Report(
        contentid: widget.content.id,
        userid: widget.content.userId,
        contentreport: _isOtherReason ? description : reason,
      );

      bool success = await reportAPI.create(report) != null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Báo cáo đã được gửi thành công'
              : 'Báo cáo đã được gửi thất bại'),
        ),
      );

      if (success) {
        _formKey.currentState!.reset();
        _descriptionController.clear();
        setState(() {
          _isOtherReason = false;
          _selectedReason = _reportReasons[0];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Báo cáo',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 48),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage(widget.content.photo), // URL ảnh đại diện của người đăng bài
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.content.fullname, // Tên người đăng bài
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Chọn lý do báo cáo:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedReason,
                items: _reportReasons.map((String reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedReason = newValue!;
                    _isOtherReason = newValue == 'Cái khác';
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_isOtherReason) ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  child: Text('Gửi'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF25A0B0)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
