import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/stockist/data/models/raw_material/add_raw_material_stock.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_raw_material_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_order_status_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_unit_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_warehouses_cubit.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
class AddRawMaterialStockPage extends StatefulWidget {
  const AddRawMaterialStockPage({Key? key}) : super(key: key);

  @override
  _AddRawMaterialStockPageState createState() =>
      _AddRawMaterialStockPageState();
}

class _AddRawMaterialStockPageState extends State<AddRawMaterialStockPage> {
  final _formKey = GlobalKey<FormState>();

  int? rawMaterialId;
  String? unitName; // Instead of unitId, we now store the unitName
  int? vendorId;
  int? warehouseId;
  int? orderStatusId;
  double? price;
  int? quantity;
  DateTime? purchaseDate;
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    final branchId = 1; // Example branch ID, replace with dynamic data if needed
    context.read<GetRawMaterialTypeCubit>().fetchRawMaterialTypes(branchId: branchId);
    context.read<GetUnitCubit>().fetchUnits(branchId: branchId);
    context.read<GetVendorCubit>().fetchVendors(branchId: branchId);
    context.read<GetWarehousesCubit>().fetchWarehouses(branchId: branchId);
    context.read<GetOrderStatusCubit>().fetchOrderStatuses(branchId: branchId);
  }

  Future<void> _selectDate(BuildContext context, bool isPurchaseDate) async {
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
                    if (isPurchaseDate) {
                      purchaseDate = selectedDate;
                    } else {
                      expiryDate = selectedDate;
                    }
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
    return rawMaterialId != null &&
        unitName != null && // Checking unitName instead of unitId
        vendorId != null &&
        warehouseId != null &&
        orderStatusId != null &&
        quantity != null &&
        price != null &&
        purchaseDate != null &&
        expiryDate != null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final AddRawMaterialStockRequest stockRequest =
          AddRawMaterialStockRequest(
        branchId: 1, // Replace with actual branch ID
        materialId: rawMaterialId!,
        quantity: quantity!,
        unitName: unitName!, // Pass unitName instead of unitId
        price: price!,
        vendorId: vendorId!,
        warehouseId: warehouseId!,
        orderStatusId: orderStatusId!,
        purchaseDate: _formatDate(purchaseDate!),
        expiryDate: _formatDate(expiryDate!),
      );

      context.read<AddRawMaterialStockCubit>().addStock(stockRequest);
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
        title: const Text('Tambah Bahan', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        surfaceTintColor: Colors.white,
      ),
      body: BlocListener<AddRawMaterialStockCubit, AddRawMaterialStockState>(
        listener: (context, state) {
          if (state is AddRawMaterialStockSuccess) {
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Stok berhasil ditambahkan'),
                backgroundColor: AppColors.successMain,
              ),
            );
          } else if (state is AddRawMaterialStockError) {
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
              const Text('Jenis Bahan', style: AppTextStyle.bigCaptionBold),
              const SizedBox(height: 8),
              BlocBuilder<GetRawMaterialTypeCubit, GetRawMaterialTypeState>(
                builder: (context, state) {
                  if (state is GetRawMaterialTypeLoading) {
                    return _loadingDropdown();
                  } else if (state is GetRawMaterialTypeLoaded) {
                    return _buildDropdown<int>(
                      value: rawMaterialId,
                      hint: 'Pilih Jenis Bahan',
                      items: state.rawMaterials.rawMaterials.map((material) {
                        return DropdownMenuItem<int>(
                          value: material.rawMaterialId,
                          child: Text(material.rawMaterialName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          rawMaterialId = value;
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
                              return _buildDropdown<String>(
                                value: unitName, // Now store unitName
                                hint: 'Pilih Satuan',
                                items: state.unitsResponse.units.map((unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit.unitName, // Store unitName
                                    child: Text(unit.unitName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    unitName = value;
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
      symbol: 'Rp.  ', // Symbol for Rupiah
    ),
  ],
  decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Harga'),
  onChanged: (value) {
    // Remove 'Rp. ' and any extra spaces before parsing to double
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
                      items:
                          state.warehousesResponse.warehouses.map((warehouse) {
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Beli',
                            style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration:
                                  AppThemes.inputDecorationStyle.copyWith(
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Kedaluwarsa',
                            style: AppTextStyle.bigCaptionBold),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration:
                                  AppThemes.inputDecorationStyle.copyWith(
                                hintText: expiryDate != null
                                    ? _formatDate(expiryDate!)
                                    : 'Pilih',
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              validator: (value) => expiryDate == null
                                  ? 'Pilih Tanggal Kedaluwarsa'
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: AppThemes.bottomBoxDecorationDialog,
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AddRawMaterialStockCubit, AddRawMaterialStockState>(
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
              onPressed: _isFormValid() && state is! AddRawMaterialStockLoading
                  ? _submit
                  : null,
              child: state is AddRawMaterialStockLoading
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
