import 'dart:io';

import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/submit_overtime.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/submit_overtime_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class SubmitOvertimeRequestPage extends StatefulWidget {
  const SubmitOvertimeRequestPage({Key? key}) : super(key: key);

  @override
  _SubmitOvertimeRequestPageState createState() =>
      _SubmitOvertimeRequestPageState();
}

class _SubmitOvertimeRequestPageState extends State<SubmitOvertimeRequestPage> {
  final _formKey = GlobalKey<FormState>();
  int? overtimeTypeId;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? description;
  File? attachment;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch overtime types
    _fetchOvertimeTypes();
  }

  // Function to fetch overtime types
  void _fetchOvertimeTypes() {
    context.read<OvertimeTypeCubit>().fetchOvertimeTypes();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime selectedDate = DateTime.now();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryMain),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onDateChanged: (DateTime date) {
                  selectedDate = date;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                   isStartDate ? startDate = selectedDate : endDate = selectedDate;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryMain),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final status = await _handlePermission(source);

    if (status.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File? compressedFile = await _compressImage(File(pickedFile.path));
        setState(() {
          attachment = compressedFile;
        });
      }
    } else if (status.isDenied) {
      _showPermissionDialog(source);
    } else if (status.isPermanentlyDenied) {
      _showPermanentDeniedDialog();
    }
  }

  Future<PermissionStatus> _handlePermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
    } else {
      if (Platform.isAndroid) {
        status = await Permission.mediaLibrary.status;
        if (!status.isGranted) {
          status = await Permission.mediaLibrary.request();
        }
      } else {
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      }
    }

    return status;
  }

  void _showPermissionDialog(ImageSource source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Izin galeri/kamera diperlukan untuk memilih gambar.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _pickImage(source);
          },
        ),
      ),
    );
  }

  void _showPermanentDeniedDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Izin galeri/kamera ditolak secara permanen. Silakan aktifkan dari pengaturan.'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            openAppSettings();
          },
        ),
      ),
    );
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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

  bool _isFormValid() {
    return overtimeTypeId != null &&
        startDate != null &&
        startTime != null &&
        endTime != null &&
        attachment != null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formattedStartDate = dateFormatter.format(startDate!);
      final String formattedEndDate = dateFormatter.format(endDate!);

      final String formattedStartTime =
          _formatTimeOfDay(startTime!);
      final String formattedEndTime =
          _formatTimeOfDay(endTime!);

      final overtimeRequest = SubmitOvertimeRequest(
        workDate: formattedStartDate,
        startDate: formattedStartDate,
        startTime: formattedStartTime,
        endDate: formattedEndDate,
        endTime: formattedEndTime,
        description: description ?? '',
        overtimeTypeId: overtimeTypeId!,
        attachmentPath: attachment?.path,
      );

      context
          .read<SubmitOvertimeRequestCubit>()
          .submitOvertimeRequest(overtimeRequest);
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final int hour = timeOfDay.hour;
    final int minute = timeOfDay.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Form Pengajuan Lembur', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchOvertimeTypes();
        },
        color: AppColors.primaryMain,
        child: BlocListener<SubmitOvertimeRequestCubit,
            SubmitOvertimeRequestState>(
          listener: (context, state) {
            if (state is SubmitOvertimeRequestSuccess) {
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengajuan lembur berhasil'),
                  backgroundColor: AppColors.successMain,
                ),
              );
            } else if (state is SubmitOvertimeRequestError) {
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
                        const Text('Jenis Lembur', style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        BlocBuilder<OvertimeTypeCubit, OvertimeTypeState>(
                          builder: (context, state) {
                            if (state is OvertimeTypeLoading) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: DropdownButtonFormField2<int>(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: null,
                                  onChanged: null,
                                  hint: const Text('Memuat...'),
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    height: 48,
                                    width: double.infinity,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    maxHeight: 200,
                                  ),
                                ),
                              );
                            } else if (state is OvertimeTypeLoaded) {
                              return DropdownButtonFormField2<int>(
                                value: overtimeTypeId,
                                decoration: AppThemes.inputDecorationStyle.copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 0)),
                                isExpanded: true,
                                items: state.overtimeTypes.map((overtimeType) {
                                  return DropdownMenuItem<int>(
                                    value: overtimeType.id,
                                    child: Text(overtimeType.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    overtimeTypeId = value;
                                  });
                                },
                                hint: const Text('Pilih Jenis Lembur'),
                                validator: (value) => value == null
                                    ? 'Jenis lembur harus dipilih'
                                    : null,
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  height: 48,
                                  width: double.infinity,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  maxHeight: 200,
                                ),
                              );
                            } else if (state is OvertimeTypeError) {
                              return Column(
                                children: [
                                  const Text(
                                    'Gagal Memuat, Swipe Kebawah Untuk Ulangi',
                                    style: TextStyle(color: AppColors.errorMain),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: _fetchOvertimeTypes,
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDateAndTimeFields(context),
                        const SizedBox(height: 16),
                        _buildEndDateAndTimeFields(context),
                        const SizedBox(height: 16),
                        _buildDescriptionField(),
                        const SizedBox(height: 16),
                        _buildAttachmentField(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mulai Lembur', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppThemes.inputDecorationStyle.copyWith(
                      hintText: startDate != null
                          ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                          : 'Pilih',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/hrd/ic_calendar.svg",
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) => startDate == null
                        ? 'Pilih Tanggal Mulai'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppThemes.inputDecorationStyle.copyWith(
                      hintText: startTime != null
                          ? startTime!.format(context)
                          : 'Pilih',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/hrd/ic_input_clock.svg",
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) => startTime == null
                        ? 'Pilih Jam Mulai'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildEndDateAndTimeFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selesai Lembur', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppThemes.inputDecorationStyle.copyWith(
                      hintText: endDate != null
                          ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                          : 'Pilih',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/hrd/ic_calendar.svg",
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) => endDate == null
                        ? 'Pilih Tanggal Mulai'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppThemes.inputDecorationStyle.copyWith(
                      hintText: endTime != null
                          ? endTime!.format(context)
                          : 'Pilih',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/hrd/ic_input_clock.svg",
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) => endTime == null
                        ? 'Pilih Jam Mulai'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Keterangan', style: AppTextStyle.bigCaptionBold),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 3,
          decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan keterangan'),
          onChanged: (value) {
            description = value;
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lampiran', style: AppTextStyle.bigCaptionBold),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomBoxDecorationDialog,
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<SubmitOvertimeRequestCubit, SubmitOvertimeRequestState>(
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
            onPressed: _isFormValid() && state is! SubmitOvertimeRequestLoading
                ? _submit
                : null,
            child: state is SubmitOvertimeRequestLoading
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
    );
  }
}
