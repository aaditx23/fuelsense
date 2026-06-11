import 'package:flutter/material.dart';
import 'package:fuelsense/views/screens/add_bike/add_bike_validators.dart';
import 'package:fuelsense/views/widgets/common_scaffold.dart';
import 'package:fuelsense/views/widgets/dropdown_widget.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_image.dart';
import 'package:fuelsense/views/widgets/outlined_text_field.dart';

import '../../../data/dropdown_values/fuel_type.dart';

class AddBikeScreen extends StatefulWidget {
  const AddBikeScreen({super.key});

  @override
  State<AddBikeScreen> createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final _formKey = GlobalKey<FormState>();

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Add Bike',
      fab: FloatingActionButton(
        onPressed: _handleSubmit,
        child: Icon(Icons.cloud_upload),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PickImage(
                onSet: (value) {},
                defaultImage: "assets/images/default_bike.png",
                size: 200,
                circle: false,
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
