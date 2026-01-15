import 'dart:async';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import 'package:sunwinners/core/constants/app_constants.dart';
import 'package:sunwinners/core/constants/app_routes.dart';
import 'package:sunwinners/data/models/devis_model.dart';
import 'package:sunwinners/data/models/devis_response_model.dart';
import 'package:sunwinners/data/repositories/devis_repo.dart';

class DevisController extends GetxController {
  final DevisRepository devisRepo;
  DevisController({required this.devisRepo});

  final _isLoading = false.obs;
  final _devisList = <DevisModel>[].obs;
  final _currentDevis = Rxn<DevisModel>();
  final _currentResponse = Rxn<DevisResponseModel>();

  bool get isLoading => _isLoading.value;
  List<DevisModel> get devisList => _devisList;
  DevisModel? get currentDevis => _currentDevis.value;
  DevisResponseModel? get currentResponse => _currentResponse.value;

  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setDevisList(List<DevisModel> devis) {
    _devisList.assignAll(devis);
    update();
  }

  void setCurrentDevis(DevisModel? devis) {
    _currentDevis.value = devis;
    update();
  }

  void setCurrentDevisResponse(DevisResponseModel? response) {
    _currentResponse.value = response;
    update();
  }

  /// 🔹 Charger les devis du client
  Future<void> loadMyDevis() async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 loadMyDevis: Calling client API...');
      final response = await devisRepo.getMyDevis(); // Client endpoint
      print('🔍 loadMyDevis: Response status code: ${response.statusCode}');
      print('🔍 loadMyDevis: Response body type: ${response.body.runtimeType}');
      print('🔍 loadMyDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 loadMyDevis: Successfully loaded ${_devisList.length} devis',
          );
        } else {
          print('🔍 loadMyDevis: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else if (response.statusCode == 401) {
        // Handle authentication failure
        print('🔍 loadMyDevis: Authentication failed - redirecting to login');
        Get.snackbar('Erreur', 'Session expirée. Veuillez vous reconnecter.');
        await Get.find<AuthController>().logout();
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadMyDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadMyDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger les devis assignés au technicien
  Future<void> loadAssignedDevis() async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 loadAssignedDevis: Calling technician API...');
      final response = await devisRepo
          .getAssignedDevis(); // Technician endpoint
      print(
        '🔍 loadAssignedDevis: Response status code: ${response.statusCode}',
      );
      print(
        '🔍 loadAssignedDevis: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 loadAssignedDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 loadAssignedDevis: Successfully loaded ${_devisList.length} assigned devis',
          );
        } else {
          print('🔍 loadAssignedDevis: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadAssignedDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadAssignedDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger le détail d'un devis assigné
  Future<void> loadAssignedDevisDetail(int id) async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print(
        '🔍 loadAssignedDevisDetail: Calling technician API for devis ID: $id',
      );
      final response = await devisRepo.getAssignedDevisDetail(
        id,
      ); // Technician endpoint
      print(
        '🔍 loadAssignedDevisDetail: Response status code: ${response.statusCode}',
      );
      print(
        '🔍 loadAssignedDevisDetail: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 loadAssignedDevisDetail: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] != null) {
          setCurrentDevis(DevisModel.fromJson(body['devis']));
          print(
            '🔍 loadAssignedDevisDetail: Successfully loaded assigned devis detail',
          );
        } else {
          print('🔍 loadAssignedDevisDetail: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadAssignedDevisDetail: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadAssignedDevisDetail: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger tous les devis (pour les administrateurs/propriétaires)
  Future<void> loadAllDevisForAdmin() async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 loadAllDevisForAdmin: Calling admin API...');
      final response = await devisRepo.getAllDevis(); // Admin endpoint
      print(
        '🔍 loadAllDevisForAdmin: Response status code: ${response.statusCode}',
      );
      print(
        '🔍 loadAllDevisForAdmin: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 loadAllDevisForAdmin: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 loadAllDevisForAdmin: Successfully loaded ${_devisList.length} devis',
          );
        } else {
          print('🔍 loadAllDevisForAdmin: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // If unauthorized for admin endpoint, try client endpoint as fallback
        print(
          '🔍 loadAllDevisForAdmin: Admin endpoint failed, trying client endpoint as fallback...',
        );
        await _loadClientDevis();
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadAllDevisForAdmin: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadAllDevisForAdmin: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger les devis assignés à un technicien
  Future<void> loadDevisForTechnician() async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 loadDevisForTechnician: Calling technician API...');
      final response = await devisRepo
          .getAssignedDevis(); // Use technician-specific endpoint
      print(
        '🔍 loadDevisForTechnician: Response status code: ${response.statusCode}',
      );
      print(
        '🔍 loadDevisForTechnician: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 loadDevisForTechnician: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 loadDevisForTechnician: Successfully loaded ${_devisList.length} devis',
          );
        } else {
          print('🔍 loadDevisForTechnician: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadDevisForTechnician: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadDevisForTechnician: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger les détails d’un devis + les réponses (pour le client)
  Future<void> loadDevisDetail(int id) async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 loadDevisDetail: Attempting to load devis ID: $id');
      final authController = Get.find<AuthController>();
      final userRole = authController.userRole;
      print('🔍 loadDevisDetail: Current user role is: $userRole');

      Response response;

      // Charger le devis
      switch (userRole) {
        case 'owner':
        case 'admin':
          response = await devisRepo.getDevisById(id);
          break;
        case 'technician':
          response = await devisRepo.getAssignedDevisDetail(id);
          break;
        case 'client':
        default:
          response = await devisRepo.getDevisDetail(id);
      }

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] != null) {
          final devis = DevisModel.fromJson(body['devis']);
          setCurrentDevis(devis);
          print('🔍 loadDevisDetail: Successfully loaded devis details');

          // 🔥 NOUVEAU : Si client et statut "répondu", charger les réponses
          if (userRole == 'client' &&
              (devis.responses == null || devis.responses!.isEmpty)) {
            await _loadResponsesForClient(devis.id);
          }
        } else {
          Get.snackbar('Erreur', 'Données du devis manquantes');
        }
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadDevisDetail: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      // Only set loading to false and update after everything is done
      // This ensures the UI updates even after responses are loaded
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger les réponses pour un client
  Future<void> _loadResponsesForClient(int devisId) async {
    try {
      print('🔍 _loadResponsesForClient: Loading responses for devis $devisId');
      final response = await devisRepo.getDevisResponses(
        devisId,
      ); // → /devis/{id}/responses

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['responses'] is List) {
          final responses = (body['responses'] as List)
              .map((json) => DevisResponseModel.fromJson(json))
              .toList();

          // Mettre à jour le devis actuel avec les réponses
          final current = currentDevis;
          if (current != null) {
            final updatedDevis = DevisModel(
              id: current.id,
              userId: current.userId,
              typeDemandeur: current.typeDemandeur,
              date: current.date,
              reference: current.reference,
              status: current.status,
              typeDemande: current.typeDemande,
              objectif: current.objectif,
              typeInstallation: current.typeInstallation,
              typeUtilisation: current.typeUtilisation,
              typePompe: current.typePompe,
              debitEstime: current.debitEstime,
              profondeurForage: current.profondeurForage,
              capaciteReservoir: current.capaciteReservoir,
              adresseComplete: current.adresseComplete,
              toitInstallation: current.toitInstallation,
              images: current.images,
              technicianId: current.technicianId,
              createdAt: current.createdAt,
              updatedAt: current.updatedAt,
              user: current.user,
              technicians: current.technicians,
              responses: responses, // ← Ajout des réponses
            );
            setCurrentDevis(updatedDevis);
            print('🔍 _loadResponsesForClient: Responses loaded and attached');
          }
        }
      }
    } catch (e) {
      print('🔍 _loadResponsesForClient error: $e');
    }
  }

  /// 🔹 Créer un devis
  Future<void> createDevis(Map<String, dynamic> data) async {
    _isLoading.value = true;
    update();
    try {
      // Check if user is authenticated before making the API call
      final authController = Get.find<AuthController>();
      bool isAuthenticated = await authController.checkAuthStatus();

      if (!isAuthenticated) {
        print('🔍 createDevis: User not authenticated - redirecting to login');
        Get.snackbar('Erreur', 'Session expirée. Veuillez vous reconnecter.');
        Get.offAllNamed('/login');
        return;
      }

      print('🔍 createDevis: Calling API with data: $data');

      // Separate image paths from other data
      List<String>? imagePaths = data['images'] is List
          ? List<String>.from(data['images'])
          : null;

      // Remove images from the main data to avoid conflicts
      Map<String, dynamic> devisData = Map.from(data);
      devisData.remove('images');

      final response = imagePaths != null && imagePaths.isNotEmpty
          ? await devisRepo.createDevisWithImages(devisData, imagePaths)
          : await devisRepo.createDevis(devisData);

      print('🔍 createDevis: Response status code: ${response.statusCode}');
      print('🔍 createDevis: Response body type: ${response.body.runtimeType}');
      print('🔍 createDevis: Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Succès', 'Devis créé avec succès');
        // Use Timer to delay the reload to avoid setState during build
        Timer(Duration.zero, () => loadMyDevis());
        // Navigate to the devis list page instead of going back
        // Replace '/devis' with your actual list page route
        Get.toNamed(
          '/devis',
        ); // Use this to go to the list page and keep it in the stack
        // Or use Get.offAllNamed('/devis') if you want to clear the stack and go to the list page
      } else if (response.statusCode == 401) {
        // Handle authentication failure
        print('🔍 createDevis: Authentication failed - redirecting to login');
        Get.snackbar('Erreur', 'Session expirée. Veuillez vous reconnecter.');
        await Get.find<AuthController>().logout();
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec de création du devis';
        print('🔍 createDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 createDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Valider un devis
  Future<void> validateDevis(int id) async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 validateDevis: Calling API for devis ID: $id');
      final response = await devisRepo.validateDevis(id);
      print('🔍 validateDevis: Response status code: ${response.statusCode}');
      print(
        '🔍 validateDevis: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 validateDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar('Succès', 'Devis validé');
        // Use Timer to delay the reload to avoid setState during build
        Timer(Duration.zero, () => loadDevisDetail(id));
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec de validation';
        print('🔍 validateDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 validateDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Rejeter un devis
  Future<void> rejectDevis(int id) async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 rejectDevis: Calling API for devis ID: $id');
      final response = await devisRepo.rejectDevis(id);
      print('🔍 rejectDevis: Response status code: ${response.statusCode}');
      print('🔍 rejectDevis: Response body type: ${response.body.runtimeType}');
      print('🔍 rejectDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar('Succès', 'Devis rejeté');
        // Use Timer to delay the reload to avoid setState during build
        Timer(Duration.zero, () => loadDevisDetail(id));
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec du rejet';
        print('🔍 rejectDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 rejectDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger tous les devis (pour les administrateurs/techniciens)
  Future<void> loadAllDevis() async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 loadAllDevis: Calling API...');
      final response = await devisRepo.getAllDevis();
      print('🔍 loadAllDevis: Response status code: ${response.statusCode}');
      print(
        '🔍 loadAllDevis: Response body type: ${response.body.runtimeType}',
      );
      print('🔍 loadAllDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 loadAllDevis: Successfully loaded ${_devisList.length} devis',
          );
        } else {
          print('🔍 loadAllDevis: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // If unauthorized for admin endpoint, try client endpoint as fallback
        print(
          '🔍 loadAllDevis: Admin endpoint failed, trying client endpoint as fallback...',
        );
        await _loadClientDevis();
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : AppConstants.serverErrorMessage;
        print('🔍 loadAllDevis: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadAllDevis: Exception occurred: $e');
      Get.snackbar('Erreur', AppConstants.serverErrorMessage);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> assignTechnicians(int devisId, List<int> technicianIds) async {
    _isLoading.value = true;
    update();

    try {
      final response = await devisRepo.assignTechnicians(
        devisId,
        technicianIds,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Succès', 'Techniciens assignés avec succès');

        final devisJson = response.body['devis'];
        final devis = DevisModel.fromJson(devisJson);
        setCurrentDevis(devis);
      } else {
        final message = response.body['message'] ?? 'Erreur assignation';
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('❌ assignTechnicians error: $e');
      Get.snackbar('Erreur', 'Erreur serveur');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Navigate to project creation from an accepted devis
  void navigateToProjectCreation(
    int devisId, {
    int? technicianId,
    DevisResponseModel? selectedResponse,
  }) {
    Get.toNamed(
      AppRoutes.projectCreate,
      arguments: [devisId, technicianId, selectedResponse],
    );
  }

  /// 🔹 Charger les devis avec gestion automatique des rôles (admin/client/technician)
  Future<void> loadDevisBasedOnRole() async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print(
        '🔍 loadDevisBasedOnRole: Attempting to load devis based on user role...',
      );

      // Get the current user's role from AuthController
      final authController = Get.find<AuthController>();
      final userRole = authController.userRole;

      print('🔍 loadDevisBasedOnRole: Current user role is: $userRole');

      switch (userRole) {
        case 'owner':
        case 'admin': // Assuming admin has similar privileges to owner
          await _loadAllDevisForAdmin();
          break;
        case 'technician':
          await _loadDevisForTechnician();
          break;
        case 'client':
          await _loadClientDevis();
          break;
        default:
          print(
            '🔍 loadDevisBasedOnRole: Unknown user role: $userRole, defaulting to client view',
          );
          await _loadClientDevis();
      }
    } catch (e) {
      print('🔍 loadDevisBasedOnRole: Exception occurred: $e');
      // Fallback to client endpoint if anything goes wrong
      await _loadClientDevis();
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger tous les devis pour admin/owner
  Future<void> _loadAllDevisForAdmin() async {
    try {
      print('🔍 _loadAllDevisForAdmin: Calling admin API...');
      final response = await devisRepo.getAllDevis(); // Admin endpoint
      print(
        '🔍 _loadAllDevisForAdmin: Response status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 _loadAllDevisForAdmin: Successfully loaded ${_devisList.length} devis via admin endpoint',
          );
        } else {
          print(
            '🔍 _loadAllDevisForAdmin: Unexpected response format from admin endpoint',
          );
          setDevisList([]);
        }
      } else {
        print(
          '🔍 _loadAllDevisForAdmin: Admin endpoint failed (${response.statusCode})',
        );
        setDevisList([]);
        _handleApiError(response);
      }
    } catch (e) {
      print('🔍 _loadAllDevisForAdmin: Exception occurred: $e');
      setDevisList([]);
    }
  }

  /// 🔹 Charger les devis assignés à un technicien
  Future<void> _loadDevisForTechnician() async {
    try {
      print('🔍 _loadDevisForTechnician: Calling technician API...');
      final response = await devisRepo
          .getAssignedDevis(); // Technician-specific endpoint
      print(
        '🔍 _loadDevisForTechnician: Response status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 _loadDevisForTechnician: Successfully loaded ${_devisList.length} devis via technician endpoint',
          );
        } else {
          print(
            '🔍 _loadDevisForTechnician: Unexpected response format from technician endpoint',
          );
          setDevisList([]);
        }
      } else {
        print(
          '🔍 _loadDevisForTechnician: Technician endpoint failed (${response.statusCode})',
        );
        setDevisList([]);
        _handleApiError(response);
      }
    } catch (e) {
      print('🔍 _loadDevisForTechnician: Exception occurred: $e');
      setDevisList([]);
    }
  }

  /// 🔹 Charger les devis du client
  Future<void> _loadClientDevis() async {
    try {
      print('🔍 _loadClientDevis: Calling client API...');
      final response = await devisRepo.getMyDevis(); // Client endpoint
      print(
        '🔍 _loadClientDevis: Response status code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] is List) {
          setDevisList(
            (body['devis'] as List)
                .map((json) => DevisModel.fromJson(json))
                .toList(),
          );
          print(
            '🔍 _loadClientDevis: Successfully loaded ${_devisList.length} devis via client endpoint',
          );
        } else {
          print(
            '🔍 _loadClientDevis: Unexpected response format from client endpoint',
          );
          setDevisList([]);
        }
      } else {
        print(
          '🔍 _loadClientDevis: Client endpoint failed (${response.statusCode})',
        );
        setDevisList([]);
        _handleApiError(response);
      }
    } catch (e) {
      print('🔍 _loadClientDevis: Exception occurred: $e');
      setDevisList([]);
    }
  }

  /// 🔹 Charger le formulaire de réponse à un devis (devis + composants disponibles)
  Future<void> loadRespondToDevisForm(int devisId) async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 loadRespondToDevisForm: Loading form for devis ID: $devisId');
      final response = await devisRepo.getAssignedDevisDetail(
        devisId,
      ); // Using the same endpoint to get devis details
      print(
        '🔍 loadRespondToDevisForm: Response status code: ${response.statusCode}',
      );
      print('🔍 loadRespondToDevisForm: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['devis'] != null) {
          setCurrentDevis(DevisModel.fromJson(body['devis']));
          print('🔍 loadRespondToDevisForm: Successfully loaded devis details');
        } else {
          print('🔍 loadRespondToDevisForm: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec du chargement du formulaire';
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadRespondToDevisForm: Exception occurred: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors du chargement du formulaire',
      );
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Répondre à un devis avec des composants
  Future<void> respondToDevis(
    int devisId,
    Map<String, dynamic> responseData,
  ) async {
    _isLoading.value = true;
    update(); // ⚡️ met à jour l’UI
    try {
      print('🔍 respondToDevis: Sending response for devis ID: $devisId');
      print('🔍 respondToDevis: Request data: $responseData');
      final response = await devisRepo.respondToDevis(devisId, responseData);
      print('🔍 respondToDevis: Response status code: ${response.statusCode}');
      print('🔍 respondToDevis: Response body: ${response.body}');

      if (response.statusCode == 201) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['response'] != null) {
          Get.snackbar(
            'Succès',
            body['message'] ?? 'Réponse envoyée avec succès',
          );
          // Optionally reload the devis list to reflect the status change
          await loadAssignedDevis();
        } else {
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Erreur', 'Session expirée. Veuillez vous reconnecter.');
        Get.offAllNamed('/login');
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec de l\'envoi de la réponse';
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 respondToDevis: Exception occurred: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors de l\'envoi de la réponse',
      );
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Charger la réponse spécifique d'un technicien pour un devis
  Future<DevisResponseModel?> getMyResponseForDevis(int devisId) async {
    try {
      print(
        '🔍 getMyResponseForDevis: Loading response for devis ID: $devisId',
      );

      // Obtenir l'ID du technicien connecté
      final authController = Get.find<AuthController>();
      final currentUserId = authController.currentUser?.id;

      if (currentUserId == null) {
        print('🔍 getMyResponseForDevis: Current user ID is null');
        return null;
      }

      print('🔍 getMyResponseForDevis: Current user ID: $currentUserId');

      print(
        '🔍 getMyResponseForDevis: Fetching response for technician ID: $currentUserId',
      );

      final response = await devisRepo.getTechnicianResponseForDevis(
        devisId,
        currentUserId,
      );
      print(
        '🔍 getMyResponseForDevis: Response status code: ${response.statusCode}',
      );
      print('🔍 getMyResponseForDevis: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          // Check if response is in 'responses' array (from /technician/devis/{id}/responses endpoint)
          if (body['responses'] is List) {
            final responses = body['responses'] as List;
            if (responses.isNotEmpty) {
              // Get the first response (should be the current technician's response)
              final responseJson = responses.first;
              final responseModel = DevisResponseModel.fromJson(responseJson);
              print(
                '🔍 getMyResponseForDevis: Found response with ID: ${responseModel.id}',
              );
              print(
                '🔍 getMyResponseForDevis: Comment: ${responseModel.commentaire}',
              );
              print(
                '🔍 getMyResponseForDevis: Prix Total: ${responseModel.prixTotal}',
              );
              print(
                '🔍 getMyResponseForDevis: Status: ${responseModel.statut}',
              );
              print(
                '🔍 getMyResponseForDevis: Components count: ${responseModel.composants?.length ?? responseModel.components?.length ?? 0}',
              );
              final components =
                  responseModel.composants ?? responseModel.components;
              if (components != null) {
                for (int i = 0; i < components.length; i++) {
                  print(
                    '🔍 getMyResponseForDevis: Component ${i + 1}: ID=${components[i].composantId}, Quantity=${components[i].quantity}, UnitPrice=${components[i].unitPrice}, TotalPrice=${components[i].totalPrice}',
                  );
                }
              }
              return responseModel;
            }
          }
          // Check if response is directly in 'response' key (as previously expected)
          else if (body['response'] != null) {
            final responseModel = DevisResponseModel.fromJson(body['response']);
            print(
              '🔍 getMyResponseForDevis: Found response with ID: ${responseModel.id}',
            );
            print(
              '🔍 getMyResponseForDevis: Comment: ${responseModel.commentaire}',
            );
            print(
              '🔍 getMyResponseForDevis: Prix Total: ${responseModel.prixTotal}',
            );
            print('🔍 getMyResponseForDevis: Status: ${responseModel.statut}');
            print(
              '🔍 getMyResponseForDevis: Components count: ${responseModel.composants?.length ?? responseModel.components?.length ?? 0}',
            );
            final components =
                responseModel.composants ?? responseModel.components;
            if (components != null) {
              for (int i = 0; i < components.length; i++) {
                print(
                  '🔍 getMyResponseForDevis: Component ${i + 1}: ID=${components[i].composantId}, Quantity=${components[i].quantity}, UnitPrice=${components[i].unitPrice}, TotalPrice=${components[i].totalPrice}',
                );
              }
            }
            return responseModel;
          }
          // Check if response is in 'devis.responses' array (from the JSON example)
          else if (body['devis'] != null &&
              body['devis']['responses'] is List) {
            final responses = body['devis']['responses'] as List;
            // Find the response for the current technician
            final technicianResponse = responses.firstWhere(
              (resp) => resp['technician_id'] == currentUserId,
              orElse: () => null,
            );

            if (technicianResponse != null) {
              final responseModel = DevisResponseModel.fromJson(
                technicianResponse,
              );
              print(
                '🔍 getMyResponseForDevis: Found response with ID: ${responseModel.id}',
              );
              print(
                '🔍 getMyResponseForDevis: Comment: ${responseModel.commentaire}',
              );
              print(
                '🔍 getMyResponseForDevis: Prix Total: ${responseModel.prixTotal}',
              );
              print(
                '🔍 getMyResponseForDevis: Status: ${responseModel.statut}',
              );
              print(
                '🔍 getMyResponseForDevis: Components count: ${responseModel.composants?.length ?? responseModel.components?.length ?? 0}',
              );
              final components =
                  responseModel.composants ?? responseModel.components;
              if (components != null) {
                for (int i = 0; i < components.length; i++) {
                  print(
                    '🔍 getMyResponseForDevis: Component ${i + 1}: ID=${components[i].composantId}, Quantity=${components[i].quantity}, UnitPrice=${components[i].unitPrice}, TotalPrice=${components[i].totalPrice}',
                  );
                }
              }
              return responseModel;
            }
          }
        }

        print(
          '🔍 getMyResponseForDevis: Unexpected response format or no response found',
        );
        print('🔍 getMyResponseForDevis: Full body: $body');
        return null;
      } else if (response.statusCode == 404) {
        print(
          '🔍 getMyResponseForDevis: No response found for this technician and devis',
        );
        return null;
      } else if (response.statusCode == 401) {
        print(
          '🔍 getMyResponseForDevis: Unauthorized access to response details',
        );
        // Return null but log the issue - this might be an API configuration issue
        return null;
      } else {
        print('🔍 getMyResponseForDevis: Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('🔍 getMyResponseForDevis: Exception occurred: $e');
      return null;
    }
  }

  /// 🔹 Charger les détails de la réponse d'un technicien pour un devis
  Future<void> loadTechnicianResponseDetails(int devisId) async {
    _isLoading.value = true;
    update();
    try {
      print(
        '🔍 loadTechnicianResponseDetails: Loading response for devis ID: $devisId',
      );

      // Get the current user's ID
      final authController = Get.find<AuthController>();
      final currentUserId = authController.currentUser?.id;

      if (currentUserId == null) {
        Get.snackbar('Erreur', 'Utilisateur non authentifié');
        return;
      }

      final response = await devisRepo.getTechnicianResponseForDevis(
        devisId,
        currentUserId,
      );
      print(
        '🔍 loadTechnicianResponseDetails: Response status: ${response.statusCode}',
      );
      print(
        '🔍 loadTechnicianResponseDetails: Response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          // Check if response is in 'responses' array (from /technician/devis/{id}/responses endpoint)
          if (body['responses'] is List) {
            final responses = body['responses'] as List;
            if (responses.isNotEmpty) {
              // Get the first response (should be the current technician's response)
              final responseJson = responses.first;
              final responseModel = DevisResponseModel.fromJson(responseJson);
              setCurrentDevisResponse(responseModel);
              print(
                '🔍 loadTechnicianResponseDetails: Successfully loaded technician response details',
              );
            } else {
              print(
                '🔍 loadTechnicianResponseDetails: No response found in the responses array',
              );
              Get.snackbar('Info', 'Aucune réponse trouvée pour ce devis');
            }
          }
          // Check if response is directly in 'response' key (as previously expected)
          else if (body['response'] != null) {
            final responseModel = DevisResponseModel.fromJson(body['response']);
            setCurrentDevisResponse(responseModel);
            print(
              '🔍 loadTechnicianResponseDetails: Successfully loaded technician response details',
            );
          }
          // Check if response is in 'devis.responses' array (from the JSON example)
          else if (body['devis'] != null &&
              body['devis']['responses'] is List) {
            final responses = body['devis']['responses'] as List;
            // Find the response for the current technician
            final technicianResponse = responses.firstWhere(
              (resp) => resp['technician_id'] == currentUserId,
              orElse: () => null,
            );

            if (technicianResponse != null) {
              final responseModel = DevisResponseModel.fromJson(
                technicianResponse,
              );
              setCurrentDevisResponse(responseModel);
              print(
                '🔍 loadTechnicianResponseDetails: Successfully loaded technician response details',
              );
            } else {
              print(
                '🔍 loadTechnicianResponseDetails: No response found for this technician in the responses array',
              );
              Get.snackbar('Info', 'Aucune réponse trouvée pour ce devis');
            }
          } else {
            print(
              '🔍 loadTechnicianResponseDetails: Unexpected response format',
            );
            Get.snackbar('Erreur', 'Format de réponse inattendu');
          }
        } else {
          print('🔍 loadTechnicianResponseDetails: Unexpected response format');
          Get.snackbar('Erreur', 'Format de réponse inattendu');
        }
      } else if (response.statusCode == 404) {
        print(
          '🔍 loadTechnicianResponseDetails: No response found for this technician and devis',
        );
        Get.snackbar('Info', 'Aucune réponse trouvée pour ce devis');
      } else if (response.statusCode == 401) {
        print(
          '🔍 loadTechnicianResponseDetails: Unauthorized access to response details',
        );
        Get.snackbar('Erreur', 'Accès non autorisé aux détails de la réponse');
      } else {
        final message =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message']
            : 'Échec du chargement des détails de la réponse';
        print('🔍 loadTechnicianResponseDetails: Error response: $message');
        Get.snackbar('Erreur', message);
      }
    } catch (e) {
      print('🔍 loadTechnicianResponseDetails: Exception occurred: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors du chargement des détails de la réponse',
      );
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// 🔹 Naviguer vers les détails de la réponse
  void navigateToResponseDetail(int devisId, {int? responseId}) {
    Get.toNamed(
      '/technician/response/detail',
      arguments: {'devisId': devisId, 'responseId': responseId},
    );
  }

  /// 🔹 Charger et afficher les détails de la réponse
  Future<void> loadAndShowResponseDetail(int devisId) async {
    await loadTechnicianResponseDetails(devisId);
    if (currentResponse != null) {
      navigateToResponseDetail(devisId);
    } else {
      Get.snackbar('Erreur', 'Aucune réponse trouvée pour ce devis');
    }
  }

  /// 🔹 Handle API errors appropriately
  void _handleApiError(Response response) {
    if (response.statusCode == 401) {
      Get.snackbar(
        'Erreur',
        'Authentification requise. Veuillez vous reconnecter.',
      );
      Get.offAllNamed('/login');
    } else if (response.statusCode == 403) {
      Get.snackbar(
        'Erreur',
        'Accès refusé. Vous n\'avez pas les permissions nécessaires.',
      );
    } else {
      final message = (response.body is Map && response.body['message'] != null)
          ? response.body['message']
          : AppConstants.serverErrorMessage;
      Get.snackbar('Erreur', message);
    }
  }
}
