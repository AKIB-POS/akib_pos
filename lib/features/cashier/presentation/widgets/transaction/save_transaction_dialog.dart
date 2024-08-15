import 'package:akib_pos/common/app_colors.dart';
import 'package:flutter/material.dart';

class SaveTransactionDialog extends StatefulWidget {
  final Function(String) onSave;

  SaveTransactionDialog({required this.onSave});

  @override
  _SaveTransactionDialogState createState() => _SaveTransactionDialogState();
}

class _SaveTransactionDialogState extends State<SaveTransactionDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Simpan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Keterangan (Optional)',
                hintText: 'Masukkan Keterangan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSave(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan Pesanan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain, // Update to match your style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
