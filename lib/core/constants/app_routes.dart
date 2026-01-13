import 'package:get/get.dart';
import 'package:sunwinners/views/auth/login_view.dart';
import 'package:sunwinners/views/auth/register_view.dart';
import 'package:sunwinners/views/auth/splash_view.dart';
import 'package:sunwinners/views/dashboard/client_dashboard_view.dart';
import 'package:sunwinners/views/dashboard/owner_dashboard_view.dart';
import 'package:sunwinners/views/dashboard/technician_dashboard_view.dart';
import 'package:sunwinners/views/devis/devis_create_view.dart';
import 'package:sunwinners/views/devis/devis_detail_view.dart';
import 'package:sunwinners/views/devis/client/devis_detail_view.dart';
import 'package:sunwinners/views/devis/owner/devis_detail_view.dart';
import 'package:sunwinners/views/devis/technician/devis_detail_view.dart';
import 'package:sunwinners/views/devis/devis_list_view.dart';
import 'package:sunwinners/views/devis/technician/devis_list_view.dart';
import 'package:sunwinners/views/devis/client/devis_list_view.dart';
import 'package:sunwinners/views/devis/owner/devis_list_view.dart';
import 'package:sunwinners/views/profile/profile_view.dart';
import 'package:sunwinners/views/project/project_create_view.dart';
import 'package:sunwinners/views/project/project_detail_view.dart';
import 'package:sunwinners/views/project/project_list_view.dart';
import 'package:sunwinners/views/subvention/subvention_detail_view.dart';
import 'package:sunwinners/views/subvention/subvention_list_view.dart';
import 'package:sunwinners/views/users/user_management_view.dart';
import 'package:sunwinners/views/users/technician_approval_view.dart';
import 'package:sunwinners/views/composant/technician/composant_list_view.dart';
import 'package:sunwinners/views/composant/technician/composant_detail_view.dart';
import 'package:sunwinners/views/composant/composant_form_view.dart';
import 'package:sunwinners/views/devis/technician/respond_to_devis_view.dart';
import 'package:sunwinners/views/devis/technician/my_responses_view.dart';
import 'package:sunwinners/views/pages/technician/devis_response_detail_page.dart';
import 'package:sunwinners/views/devis/owner/assign_technicians_view.dart';

class AppRoutes {
  // AUTH
  static const String login = '/login';
  static const String register = '/register';
  static const String splash = '/';

  // PROFILE
  static const String profile = '/profile';

  // DASHBOARD
  static const String clientDashboard = '/client/dashboard';
  static const String technicianDashboard = '/technician/dashboard';
  static const String ownerDashboard = '/owner/dashboard';

  // DEVIS
  static const String devisList = '/devis';
  static const String clientDevisList = '/client/devis';
  static const String technicianDevisList = '/technician/devis';
  static const String ownerDevisList = '/owner/devis';
  static const String devisCreate = '/devis/create';
  static const String devisDetail = '/devis/detail';
  static const String clientDevisDetail = '/client/devis/detail';
  static const String technicianDevisDetail = '/technician/devis/detail';
  static const String ownerDevisDetail = '/owner/devis/detail';

  // PROJECT
  static const String projectList = '/project';
  static const String projectDetail = '/project/detail';
  static const String projectCreate = '/project/create';

  // SUBVENTION
  static const String subventionList = '/subvention';
  static const String subventionDetail = '/subvention/detail';

  // USER MANAGEMENT
  static const String userManagement = '/users/management';
  static const String technicianApproval = '/technicians/approval';

  // TECHNICIAN DEVIS
  static const String technicianRespondToDevis = '/technician/devis/respond';
  static const String technicianMyResponses = '/technician/responses';
  static const String technicianResponseDetail = '/technician/response/detail';

  // OWNER DEVIS
  static const String ownerAssignTechnicians =
      '/owner/devis/assign-technicians';

  // COMPONENTS
  static const String composantList = '/composant';
  static const String composantCreate = '/composant/create';
  static const String composantEdit = '/composant/edit';
  static const String composantDetail = '/composant/detail';

  static final routes = [
    // AUTH
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(name: splash, page: () => const SplashView()),

    // PROFILE
    GetPage(name: profile, page: () => const ProfileView()),

    // DASHBOARD
    GetPage(name: clientDashboard, page: () => const ClientDashboardView()),
    GetPage(
      name: technicianDashboard,
      page: () => const TechnicianDashboardView(),
    ),
    GetPage(name: ownerDashboard, page: () => const OwnerDashboardView()),

    // DEVIS
    GetPage(name: devisList, page: () => const DevisListView()),
    GetPage(name: clientDevisList, page: () => const ClientDevisListView()),
    GetPage(
      name: technicianDevisList,
      page: () => const TechnicianDevisListView(),
    ),
    GetPage(name: ownerDevisList, page: () => const OwnerDevisListView()),
    GetPage(name: devisCreate, page: () => const DevisCreateView()),
    GetPage(
      name: devisDetail,
      page: () => DevisDetailPage(
        devisId: Get.arguments as int, // ⚡️ récupère l'id passé à la navigation
      ),
    ),
    GetPage(
      name: clientDevisDetail,
      page: () => ClientDevisDetailPage(devisId: Get.arguments as int),
    ),
    GetPage(
      name: technicianDevisDetail,
      page: () => TechnicianDevisDetailPage(devisId: Get.arguments as int),
    ),
    GetPage(
      name: ownerDevisDetail,
      page: () => OwnerDevisDetailPage(devisId: Get.arguments as int),
    ),

    // PROJECT
    GetPage(name: projectList, page: () => const ProjectListView()),
    GetPage(name: projectDetail, page: () => const ProjectDetailView()),
    GetPage(
      name: projectCreate,
      page: () => ProjectCreateView(
        devisId: (Get.arguments is Map<String, dynamic>)
            ? Get.arguments['devisId'] ?? 0
            : (Get.arguments is List)
            ? Get.arguments[0] ?? 0
            : 0,
        technicianId: (Get.arguments is Map<String, dynamic>)
            ? Get.arguments['technicianId']
            : (Get.arguments is List)
            ? Get.arguments[1]
            : null,
        selectedResponse: (Get.arguments is Map<String, dynamic>)
            ? Get.arguments['selectedResponse']
            : (Get.arguments is List)
            ? Get.arguments[2]
            : null,
      ),
    ),

    // COMPONENTS
    GetPage(
      name: AppRoutes.composantList,
      page: () => const ComposantListView(),
    ),
    GetPage(
      name: AppRoutes.composantDetail,
      page: () => ComposantDetailView(composantId: Get.arguments as int),
    ),
    GetPage(
      name: AppRoutes.composantCreate,
      page: () => const ComposantFormView(isEditing: false),
    ),
    GetPage(
      name: AppRoutes.composantEdit,
      page: () => ComposantFormView(
        isEditing: true,
        composantId: Get.arguments as int?,
      ),
    ),

    // TECHNICIAN DEVIS
    GetPage(
      name: AppRoutes.technicianRespondToDevis,
      page: () => RespondToDevisView(devisId: Get.arguments as int),
    ),
    GetPage(
      name: AppRoutes.technicianMyResponses,
      page: () => const MyResponsesView(),
    ),
    GetPage(
      name: AppRoutes.technicianResponseDetail,
      page: () {
        if (Get.arguments is Map<String, dynamic>) {
        } else if (Get.arguments is List) {}

        // Don't load the response details here to avoid setState during build
        // The page will handle loading in its init method
        return DevisResponseDetailPage();
      },
    ),

    // OWNER DEVIS
    GetPage(
      name: AppRoutes.ownerAssignTechnicians,
      page: () => AssignTechniciansPage(devisId: Get.arguments as int),
    ),

    // SUBVENTION
    GetPage(name: subventionList, page: () => const SubventionListView()),
    GetPage(name: subventionDetail, page: () => const SubventionDetailView()),

    // USER MANAGEMENT
    GetPage(name: userManagement, page: () => const UserManagementView()),
    GetPage(
      name: technicianApproval,
      page: () => const TechnicianApprovalView(),
    ),
  ];
}
