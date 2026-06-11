import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/presentation/screens/add_bike/add_bike_notifier.dart';
import 'package:fuelsense/presentation/screens/add_bike/add_bike_validators.dart';
import 'package:fuelsense/presentation/screens/pending_bikes/pending_bikes_notifier.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/widgets/dropdown_widget.dart';
import 'package:fuelsense/presentation/widgets/image_picker/pick_image.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

import '../../data/dropdown_values/fuel_type.dart';

/*
response message: show as toast on top
fix flicker and change loading indicator to animation
*/

class EditBikeScreen extends ConsumerStatefulWidget {
  final Bike bike;
  const EditBikeScreen({super.key, required this.bike});

  @override
  ConsumerState<EditBikeScreen> createState() => _EditBikeScreenState();
}

class _EditBikeScreenState extends ConsumerState<EditBikeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _isLoading = false;

  // Text controllers for form fields
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _engineCcController = TextEditingController();
  final _modelYearController = TextEditingController();
  final _expectedMileageController = TextEditingController();
  final _tankCapacityController = TextEditingController();
  final _reserveCapacityController = TextEditingController();

  // Fuel type selection
  String _selectedFuelType = fuelType[0];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _brandController.text = widget.bike.brand;
    _modelController.text = widget.bike.model;
    _engineCcController.text = widget.bike.engineCc.toString();
    _modelYearController.text = widget.bike.modelYear.toString();
    _expectedMileageController.text = widget.bike.expectedMileage.toString();
    _tankCapacityController.text = widget.bike.tankCapacity.toString();
    _reserveCapacityController.text =
        widget.bike.reserveCapacity?.toString() ?? "";
    _selectedImage = widget.bike.image;
    _selectedFuelType = widget.bike.fuelType;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _engineCcController.dispose();
    _modelYearController.dispose();
    _expectedMileageController.dispose();
    _tankCapacityController.dispose();
    _reserveCapacityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final bikeRequest = BikeRequest(
        brand: _brandController.text,
        model: _modelController.text,
        engineCc: int.parse(_engineCcController.text.trim()),
        modelYear: int.parse(_modelYearController.text.trim()),
        fuelType: _selectedFuelType,
        expectedMileage: double.parse(_expectedMileageController.text.trim()),
        tankCapacity: double.parse(_tankCapacityController.text.trim()),
        image: _selectedImage,
        reserveCapacity: double.parse(_reserveCapacityController.text)
      );
      await ref
          .read(pendingBikesNotifierProvider.notifier)
          .editBike(widget.bike.id, bikeRequest);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addBikeNotifierProvider);

    return CommonScaffold(
      showDrawer: false,
      title: 'Edit Bike',
      fab: state.isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await _handleSubmit();
              },
              child: Icon(Icons.save),
            ),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PickImage(
                      onSet: (value) {
                        if (value != null) _selectedImage = value;
                        setState(() {});
                      },
                      defaultImage: "assets/images/default_bike.png",
                      size: 200,
                      circle: false,
                      selectedImage: _selectedImage,
                    ),
                    const SizedBox(height: 16),

                    // Brand field
                    OutlinedTextField(
                      controller: _brandController,
                      labelText: 'Brand',
                      hintText: 'Enter bike brand',
                      prefixIcon: const Icon(Icons.business),
                      validator: AddBikeValidators.validateBrand,
                    ),
                    const SizedBox(height: 16),

                    // Model field
                    OutlinedTextField(
                      controller: _modelController,
                      labelText: 'Model',
                      hintText: 'Enter bike model',
                      prefixIcon: const Icon(Icons.two_wheeler),
                      validator: AddBikeValidators.validateModel,
                    ),
                    const SizedBox(height: 16),

                    // Engine CC field
                    OutlinedTextField(
                      controller: _engineCcController,
                      labelText: 'Engine CC',
                      hintText: 'Enter engine capacity',
                      prefixIcon: const Icon(Icons.speed),
                      keyboardType: TextInputType.number,
                      validator: AddBikeValidators.validateEngineCC,
                    ),
                    const SizedBox(height: 16),

                    // Model Year field
                    OutlinedTextField(
                      controller: _modelYearController,
                      labelText: 'Model Year',
                      hintText: 'Enter model year',
                      prefixIcon: const Icon(Icons.calendar_today),
                      keyboardType: TextInputType.number,
                      validator: AddBikeValidators.validateModelYear,
                    ),
                    const SizedBox(height: 16),

                    // Fuel Type dropdown
                    DropdownWidget(
                      items: fuelType,
                      onChanged: (value) {
                        _selectedFuelType = value ?? "";
                      },
                      labelText: "Fuel Type",
                      prefixIcon: Icons.local_gas_station,
                    ),
                    const SizedBox(height: 16),

                    // Expected Mileage field
                    OutlinedTextField(
                      controller: _expectedMileageController,
                      labelText: 'Expected Mileage (km/l)',
                      hintText: 'Enter expected mileage',
                      prefixIcon: const Icon(Icons.analytics),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: AddBikeValidators.validateExpectedMileage,
                    ),
                    const SizedBox(height: 16),

                    // Tank Capacity field
                    OutlinedTextField(
                      controller: _tankCapacityController,
                      labelText: 'Tank Capacity (liters)',
                      hintText: 'Enter tank capacity',
                      prefixIcon: const Icon(Icons.water_drop),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: AddBikeValidators.validateTankCapacity,
                    ),
                    const SizedBox(height: 16),

                    // Reserve Capacity field (optional)
                    OutlinedTextField(
                      controller: _reserveCapacityController,
                      labelText: 'Reserve Capacity (liters)',
                      hintText: 'Enter reserve capacity (optional)',
                      prefixIcon: const Icon(Icons.water_drop_outlined),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: AddBikeValidators.validateReserveCapacity,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
