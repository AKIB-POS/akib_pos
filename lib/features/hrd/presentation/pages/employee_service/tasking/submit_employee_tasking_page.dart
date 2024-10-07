import 'dart:io';

import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/submit_employee_tasking_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/submit_employee_tasking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class SubmitEmployeeTaskingPage extends StatefulWidget {
  final int taskId;

  const SubmitEmployeeTaskingPage({Key? key, required this.taskId}) : super(key: key);

  @override
  _SubmitEmployeeTaskingPageState createState() => _SubmitEmployeeTaskingPageState();
}

class _SubmitEmployeeTaskingPageState extends State<SubmitEmployeeTaskingPage> {
  final _formKey = GlobalKey<FormState>();
  String? description;
  File? attachment;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Upload Tasking', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
      ),
      body: BlocListener<SubmitEmployeeTaskingCubit, SubmitEmployeeTaskingState>(
        listener: (context, state) {
          if (state is SubmitEmployeeTaskingSuccess) {
            // Task berhasil di-upload
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tasking berhasil diupload'),
                backgroundColor: AppColors.successMain,
              ),
            );
          } else if (state is SubmitEmployeeTaskingError) {
            // Terjadi error saat upload task
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.errorMain,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text('Keterangan', style: AppTextStyle.bigCaptionBold),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan keterangan'),
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Keterangan harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: const DashedBorder.fromBorderSide(
                            dashLength: 11,
                            side: BorderSide(color: AppColors.textGrey600, width: 1),
                          ),
                        ),
                        child: attachment != null
                            ? Image.file(attachment!)
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('*Pilih satu file', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          style: AppThemes.outlineButtonPrimaryStylePadding,
                          onPressed: () {
                            _showImageSourceActionSheet(context);
                          },
                          child: Text(
                            attachment == null ? 'Pilih Lampiran' : 'Upload Ulang',
                            style: AppTextStyle.caption.copyWith(color: AppColors.primaryMain),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: AppThemes.bottomBoxDecorationDialog,
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<SubmitEmployeeTaskingCubit, SubmitEmployeeTaskingState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid() ? AppColors.primaryMain : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _isFormValid() && state is! SubmitEmployeeTaskingLoading
                        ? _submitTask
                        : null,
                    child: state is SubmitEmployeeTaskingLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Kirim', style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    return description != null && attachment != null;
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final taskingRequest = SubmitEmployeeTaskingRequest(
        taskingId: widget.taskId,
        description: description!,
        attachmentPath: attachment?.path,
      );
      context.read<SubmitEmployeeTaskingCubit>().submitEmployeeTasking(taskingRequest);
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textGrey300,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Text('Pilih Sumber File',
                          style: AppTextStyle.bigCaptionBold
                              .copyWith(color: AppColors.primaryMain)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Kamera'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Galeri'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File? compressedFile = await _compressImage(File(pickedFile.path));
      setState(() {
        attachment = compressedFile;
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitFilePath = filePath.substring(0, lastIndex);
    final outPath = "${splitFilePath}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 85,
    );

    if (result != null) {
      return File(result.path);
    }
    return null;
  }
}
