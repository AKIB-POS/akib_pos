import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_equipment_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_order_status_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_unit_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_warehouses_cubit.dart';
import 'package:akib_pos/features/stockist/data/models/equipment/add_equipment_stock.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AddEquipmentStockPage extends StatefulWidget {
  const AddEquipmentStockPage({Key? key}) : super(key: key);

  @override
  _AddEquipmentStockPageState createState() => _AddEquipmentStockPageState();
}

class _AddEquipmentStockPageState extends State<AddEquipmentStockPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  int? equipmentId;
  int? unitId;
  int? vendorId;
  int? warehouseId;
  int? orderStatusId;
  double? price;
  int? quantity;
  DateTime? purchaseDate;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    final branchId = _authSharedPref.getBranchId() ?? 0; // Replace with dynamic branchId if needed
    context.read<GetEquipmentTypeCubit>().fetchEquipmentList(branchId: branchId, category: 'equipment');
    context.read<GetUnitCubit>().fetchUnits(branchId: branchId);
    context.read<GetVendorCubit>().fetchVendors(branchId: branchId);
    context.read<GetWarehousesCubit>().fetchWarehouses(branchId: branchId);
    context.read<GetOrderStatusCubit>().fetchOrderStatuses(branchId: branchId);
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
                    purchaseDate = selectedDate;
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

  bool _isFormValid() {
    return equipmentId != null &&
        unitId != null &&
        vendorId != null &&
        warehouseId != null &&
        orderStatusId != null &&
        quantity != null &&
        price != null &&
        purchaseDate != null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final AddEquipmentStockRequest stockRequest =
          AddEquipmentStockRequest(
        branchId: _authSharedPref.getBranchId() ?? 0 , // Replace with actual branch ID
        ingredientId: equipmentId!,
        quantity: quantity!,
        unitId: unitId!,
        price: price!,
        vendorId: vendorId!,
        warehouseId: warehouseId!,
        orderStatusId: orderStatusId!,
        expiryDate: null,
        itemType: "equipment",
        purchaseDate: _formatDate(purchaseDate!),
      );

      context.read<AddEquipmentStockCubit>().addEquipmentStock(stockRequest);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Tambah Peralatan', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
      ),
      body: BlocListener<AddEquipmentStockCubit, AddEquipmentStockState>(
        listener: (context, state) {
          if (state is AddEquipmentStockSuccess) {
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Stok peralatan berhasil ditambahkan'),
                backgroundColor: AppColors.successMain,
              ),
            );
          } else if (state is AddEquipmentStockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.errorMain,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Jenis Peralatan', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              BlocBuilder<GetEquipmentTypeCubit, GetEquipmentTypeState>(
                builder: (context, state) {
                  if (state is GetEquipmentListLoading) {
                    return _loadingDropdown();
                  } else if (state is GetEquipmentListLoaded) {
                    return _buildDropdown<int>(
                      value: equipmentId,
                      hint: 'Pilih Jenis Peralatan',
                      items: state.equipmentList.map((equipment) {
                        return DropdownMenuItem<int>(
                          value: equipment.id,
                          child: Text(equipment.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          equipmentId = value;
                        });
                      },
                    );
                  } else {
                    return _errorDropdown();
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
                        const Text('Jumlah',
                            style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: AppThemes.inputDecorationStyle
                              .copyWith(hintText: 'Jumlah'),
                          onChanged: (value) {
                            setState(() {
                              quantity = int.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Satuan', style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        BlocBuilder<GetUnitCubit, GetUnitState>(
                          builder: (context, state) {
                            if (state is GetUnitLoading) {
                              return _loadingDropdown();
                            } else if (state is GetUnitLoaded) {
                              return _buildDropdown<int>(
                                value: unitId,
                                hint: 'Pilih Satuan',
                                items: state.unitsResponse.units.map((unit) {
                                  return DropdownMenuItem<int>(
                                    value: unit.unitId,
                                    child: Text(unit.unitName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    unitId = value;
                                  });
                                },
                              );
                            } else {
                              return _errorDropdown();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Harga', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  CurrencyTextInputFormatter.currency(
                    locale: 'id',
                    decimalDigits: 0,
                    symbol: 'Rp.  ',
                  ),
                ],
                decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Harga'),
                onChanged: (value) {
                  String cleanedValue = value.replaceAll('Rp. ', '').replaceAll(',', '').trim();
                  setState(() {
                    price = double.tryParse(cleanedValue);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || price == null) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Nama Vendor', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              BlocBuilder<GetVendorCubit, GetVendorState>(
                builder: (context, state) {
                  if (state is GetVendorLoading) {
                    return _loadingDropdown();
                  } else if (state is GetVendorLoaded) {
                    return _buildDropdown<int>(
                      value: vendorId,
                      hint: 'Pilih Vendor',
                      items: state.vendorList.vendors.map((vendor) {
                        return DropdownMenuItem<int>(
                          value: vendor.vendorId,
                          child: Text(vendor.vendorName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          vendorId = value;
                        });
                      },
                    );
                  } else {
                    return _errorDropdown();
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Gudang', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              BlocBuilder<GetWarehousesCubit, GetWarehousesState>(
                builder: (context, state) {
                  if (state is GetWarehousesLoading) {
                    return _loadingDropdown();
                  } else if (state is GetWarehousesLoaded) {
                    return _buildDropdown<int>(
                      value: warehouseId,
                      hint: 'Pilih Gudang',
                      items: state.warehousesResponse.warehouses.map((warehouse) {
                        return DropdownMenuItem<int>(
                          value: warehouse.warehouseId,
                          child: Text(warehouse.warehouseName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          warehouseId = value;
                        });
                      },
                    );
                  } else {
                    return _errorDropdown();
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Status Pesanan', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              BlocBuilder<GetOrderStatusCubit, GetOrderStatusState>(
                builder: (context, state) {
                  if (state is GetOrderStatusLoading) {
                    return _loadingDropdown();
                  } else if (state is GetOrderStatusLoaded) {
                    return _buildDropdown<int>(
                      value: orderStatusId,
                      hint: 'Pilih Status Pesanan',
                      items: state.statuses.map((status) {
                        return DropdownMenuItem<int>(
                          value: status.id,
                          child: Text(status.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          orderStatusId = value;
                        });
                      },
                    );
                  } else {
                    return _errorDropdown();
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Tanggal Beli', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppThemes.inputDecorationStyle.copyWith(
                      hintText: purchaseDate != null
                          ? _formatDate(purchaseDate!)
                          : 'Pilih',
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (value) => purchaseDate == null
                        ? 'Pilih Tanggal Beli'
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: AppThemes.bottomBoxDecorationDialog,
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AddEquipmentStockCubit, AddEquipmentStockState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isFormValid() ? AppColors.primaryMain : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _isFormValid() && state is! AddEquipmentStockLoading
                  ? _submit
                  : null,
              child: state is AddEquipmentStockLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Simpan Stok',
                      style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  Widget _loadingDropdown() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: DropdownButtonFormField<int>(
        decoration: AppThemes.inputDecorationStyle
            .copyWith(contentPadding: const EdgeInsets.all(0)),
        items: const [],
        onChanged: null,
        hint: const Text('Memuat...'),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField2<T>(
      value: value,
      decoration: AppThemes.inputDecorationStyle
          .copyWith(contentPadding: const EdgeInsets.all(0)),
      items: items,
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        maxHeight: 200,
      ),
      hint: Text(hint),
      validator: (value) => value == null ? 'Field ini harus dipilih' : null,
    );
  }

  Widget _errorDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: _fetchInitialData,
          child: const Text(
            'Gagal Memuat, Ulangi',
            style: TextStyle(color: AppColors.errorMain),
          ),
        ),
      ],
    );
  }
}
