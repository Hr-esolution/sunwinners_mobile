import 'package:get/get.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import 'package:sunwinners/controllers/composant_controller.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/controllers/profile_controller.dart';
import 'package:sunwinners/controllers/project_controller.dart';
import 'package:sunwinners/controllers/subvention_controller.dart';
import 'package:sunwinners/controllers/user_controller.dart';
import 'package:sunwinners/core/network/api_client.dart';
import 'package:sunwinners/data/repositories/auth_repo.dart';
import 'package:sunwinners/data/repositories/composant_repo.dart';
import 'package:sunwinners/data/repositories/devis_repo.dart';
import 'package:sunwinners/data/repositories/profile_repo.dart';
import 'package:sunwinners/data/repositories/project_repo.dart';
import 'package:sunwinners/data/repositories/subvention_repo.dart';
import 'package:sunwinners/data/repositories/user_repo.dart';

class DependencyInjection {
  static Future<void> init() async {
    // API Client
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repositories
    Get.put<AuthRepository>(
      AuthRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<ProfileRepository>(
      ProfileRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<DevisRepository>(
      DevisRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<ProjectRepository>(
      ProjectRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<SubventionRepository>(
      SubventionRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<ComposantRepository>(
      ComposantRepository(apiClient: Get.find()),
      permanent: true,
    );
    Get.put<UserRepository>(
      UserRepository(apiClient: Get.find()),
      permanent: true,
    );

    // Controllers
    Get.put<AuthController>(
      AuthController(authRepo: Get.find()),
      permanent: true,
    );
    Get.put<ProfileController>(
      ProfileController(profileRepo: Get.find()),
      permanent: true,
    );
    Get.put<DevisController>(
      DevisController(devisRepo: Get.find()),
      permanent: true,
    );
    Get.put<ProjectController>(
      ProjectController(projectRepo: Get.find()),
      permanent: true,
    );
    Get.put<SubventionController>(
      SubventionController(subventionRepo: Get.find()),
      permanent: true,
    );
    Get.put<ComposantController>(
      ComposantController(composantRepo: Get.find()),
      permanent: true,
    );
    Get.put<UserController>(
      UserController(userRepo: Get.find()),
      permanent: true,
    );
  }
}
