import 'package:get/get.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/user_model.dart';
import 'package:minifood_admin/data/reponsitories/users_reponsitory.dart';

class UsersController extends GetxController {
  final UsersRepositoryImpl _repo = UsersRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<UserModel> admin = <UserModel>[].obs;
  final RxList<UserModel> staff = <UserModel>[].obs;
  final RxList<UserModel> user = <UserModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      admin.value = await _repo.getAllUsers('admin');
      staff.value = await _repo.getAllUsers('staff');
      user.value = await _repo.getAllUsers('user');
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
