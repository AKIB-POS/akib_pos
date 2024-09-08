import 'package:flutter/material.dart';

class ServiceChargeSettingPage extends StatefulWidget {
  final double? initialPercentage;

  const ServiceChargeSettingPage({Key? key, this.initialPercentage}) : super(key: key);

  @override
  _ServiceChargeSettingPageState createState() => _ServiceChargeSettingPageState();
}

class _ServiceChargeSettingPageState extends State<ServiceChargeSettingPage> {
  late TextEditingController _percentageController;

  @override
  void initState() {
    super.initState();
    _percentageController = TextEditingController(
      text: widget.initialPercentage?.toString() ?? '', // Inisialisasi nilai jika ada
    );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atur Biaya Pelayanan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Persentase Pelayanan",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _percentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Masukkan Persentase",
                suffixText: "%",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simpan nilai yang dimasukkan
                final enteredValue = double.tryParse(_percentageController.text);
                if (enteredValue != null) {
                  // Lakukan penyimpanan atau update
                  Navigator.pop(context, enteredValue);
                } else {
                  // Tampilkan error jika input tidak valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masukkan nilai persentase yang valid")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
