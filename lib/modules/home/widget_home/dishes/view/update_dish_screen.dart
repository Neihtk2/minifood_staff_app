import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/add_dishes_controller.dart';

class UpdateDishView extends StatelessWidget {
  const UpdateDishView({super.key});

  @override
  Widget build(BuildContext context) {
    final DishController controller =
        Get.find<DishController>(); // Lấy controller

    String dishId = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDishDetails(dishId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật món ăn'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNameField(controller),
            const SizedBox(height: 16),
            _buildPriceField(controller),
            const SizedBox(height: 16),
            _buildCategoryDropdown(controller),
            const SizedBox(height: 16),
            _buildImagePicker(controller),
            const SizedBox(height: 24),
            _buildSubmitButton(controller, dishId),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(DishController controller) {
    return TextFormField(
      controller: controller.nameController,
      decoration: const InputDecoration(
        labelText: 'Tên món ăn',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPriceField(DishController controller) {
    return TextFormField(
      controller: controller.priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Giá',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryDropdown(DishController controller) {
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
      ),
    );
  }

  Widget _buildImagePicker(DishController controller) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: controller.selectImage,
          child: const Text('Chọn ảnh món ăn'),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final image = controller.selectedImage.value;
          final imageUrl = controller.imageUpdate.value;
          if (image != null) {
            return Image.file(image, height: 200, fit: BoxFit.cover);
          } else if (imageUrl.isNotEmpty) {
            return Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Text('Lỗi tải ảnh'),
            );
          } else {
            return const Text('Chưa có ảnh món ăn');
          }
        }),
      ],
    );
  }

  Widget _buildSubmitButton(DishController controller, String dishId) {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isLoading.value
                ? null
                : () async {
                  try {
                    await controller.updateDish(dishId);
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
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Text('Cập nhật món ăn'),
      ),
    );
  }
}
