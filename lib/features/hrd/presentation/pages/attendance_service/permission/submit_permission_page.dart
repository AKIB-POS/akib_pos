import 'dart:io';

import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/permission_request.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/permission/submit_permission_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/permission_type_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/permission/submit_permission_request_cubit.dart';
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

class SubmitPermissionRequestPage extends StatefulWidget {
  const SubmitPermissionRequestPage({Key? key}) : super(key: key);

  @override
  _SubmitPermissionRequestPageState createState() => _SubmitPermissionRequestPageState();
}

class _SubmitPermissionRequestPageState extends State<SubmitPermissionRequestPage> {
  final _formKey = GlobalKey<FormState>();
  int? permissionTypeId;
  DateTime? workDate;
  TimeOfDay? timeIn;
  String? description;
  File? attachment;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Trigger cubit to fetch permission types
    _fetchPermissionTypes();
  }

  // Function to fetch permission types
  void _fetchPermissionTypes() {
    context.read<PermissionTypeCubit>().fetchPermissionTypes();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
            ),
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
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
                    workDate = selectedDate;
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

  Future<void> _selectTime(BuildContext context) async {
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

    if (picked != null && picked != selectedTime) {
      setState(() {
        timeIn = picked;
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
        content: const Text('Izin galeri/kamera diperlukan untuk memilih gambar.'),
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
        content: const Text('Izin galeri/kamera ditolak secara permanen. Silakan aktifkan dari pengaturan.'),
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
    return permissionTypeId != null &&
        workDate != null &&
        timeIn != null &&
        attachment != null;
  }

  void _submit() {
  if (_formKey.currentState!.validate()) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final String formattedWorkDate = dateFormatter.format(workDate!);

    // Convert TimeOfDay to 24-hour format (HH:mm)
    final String formattedTimeIn = timeIn != null
        ? _formatTimeOfDay(timeIn!)
        : ''; 

    final permissionRequest = SubmitPermissionRequest(
      permissionTypeId: permissionTypeId!,
      workDate: formattedWorkDate,
      timeIn: formattedTimeIn,
      description: description ?? '',
      attachmentPath: attachment?.path,
    );
    context.read<SubmitPermissionRequestCubit>().submitPermissionRequest(permissionRequest);
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
        title: const Text('Form Pengajuan Izin', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          _fetchPermissionTypes();
        },
        color: AppColors.primaryMain,
        child: BlocListener<SubmitPermissionRequestCubit, SubmitPermissionRequestState>(
          listener: (context, state) {
            if (state is SubmitPermissionRequestSuccess) {
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengajuan izin berhasil'),
                  backgroundColor: AppColors.successMain,
                ),
              );
            } else if (state is SubmitPermissionRequestError) {
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
                        const Text('Jenis Izin', style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        BlocBuilder<PermissionTypeCubit, PermissionTypeState>(
                          builder: (context, state) {
                            if (state is PermissionTypeLoading) {
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
                            } else if (state is PermissionTypeLoaded) {
                              return DropdownButtonFormField2<int>(
                                value: permissionTypeId,
                                decoration: AppThemes.inputDecorationStyle.copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 0)),
                                isExpanded: true,
                                items: state.permissionTypes.map((permissionType) {
                                  return DropdownMenuItem<int>(
                                    value: permissionType.id,
                                    child: Text(permissionType.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    permissionTypeId = value;
                                  });
                                },
                                hint: const Text('Pilih Jenis Izin'),
                                validator: (value) => value == null
                                    ? 'Jenis izin harus dipilih'
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
                            } else if (state is PermissionTypeError) {
                              return Column(
                                children: [
                                  const Text(
                                    'Gagal Memuat, Swipe Kebawah Untuk Ulangi',
                                    style: TextStyle(color: AppColors.errorMain),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: _fetchPermissionTypes, // Retry fetching
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tanggal Kerja', style: AppTextStyle.bigCaptionBold),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: AppThemes.inputDecorationStyle.copyWith(
                                          hintText: workDate != null
                                              ? "${workDate!.day}/${workDate!.month}/${workDate!.year}"
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
                                        validator: (value) => workDate == null
                                            ? 'Pilih Tanggal Kerja'
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
                                  const Text('Jam Masuk', style: AppTextStyle.bigCaptionBold),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _selectTime(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: AppThemes.inputDecorationStyle.copyWith(
                                          hintText: timeIn != null
                                              ? timeIn!.format(context)
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
                                        validator: (value) => timeIn == null
                                            ? 'Pilih Jam Masuk'
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Keterangan', style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        TextFormField(
                          maxLines: 3,
                          decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan keterangan'),
                          onChanged: (value) {
                            description = value;
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
                              attachment == null
                                  ? 'Pilih Lampiran'
                                  : 'Upload Ulang',
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
                child: BlocBuilder<SubmitPermissionRequestCubit, SubmitPermissionRequestState>(
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
                      onPressed: _isFormValid() && state is! SubmitPermissionRequestLoading
                          ? _submit
                          : null,
                      child: state is SubmitPermissionRequestLoading
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
      ),
    );
  }
}