// 3. View (lib/app/views/add_dish_view.dart)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/add_dishes_controller.dart';

class AddDishView extends GetView<DishController> {
  const AddDishView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm món mới'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildPriceField(),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      decoration: const InputDecoration(
        labelText: 'Tên món ăn',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập tên' : null,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: controller.priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Giá',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Vui lòng nhập giá';
        if (double.tryParse(value!) == null) return 'Giá không hợp lệ';
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value:
            controller.category.value.isEmpty
                ? null
                : controller.category.value,
        items:
            controller.categories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: (value) => controller.category.value = value ?? '',
        decoration: const InputDecoration(
          labelText: 'Danh mục',
          border: OutlineInputBorder(),
        ),
        validator:
            (value) => value?.isEmpty ?? true ? 'Vui lòng chọn danh mục' : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: controller.selectImage,
          child: const Text('Chọn ảnh món ăn'),
        ),
        const SizedBox(height: 8),
        Obx(
          () =>
              controller.selectedImage.value != null
                  ? Image.file(
                    controller.selectedImage.value!,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                  : const Text('Chưa chọn ảnh'),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isLoading.value
                ? null
                : () async {
                  try {
                    await controller.createDish();
                  } catch (e) {
                    Get.snackbar(
                      'Lỗi',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
        child:
            controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Thêm món'),
      ),
    );
  }
}
