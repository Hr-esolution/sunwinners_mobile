import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../data/models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.find();
  final AuthController authController = Get.find();
  bool _isEditing = false;
  String? _selectedImagePath;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _certificatesController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _licenseStatusController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _certificatesController.dispose();
    _experienceController.dispose();
    _licenseStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFffd60a)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffd60a).withValues(alpha: 0.15),
                const Color(0xFFffc300).withValues(alpha: 0.08),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1f2e),
              const Color(0xFF0f1419),
              const Color(0xFF051628),
            ],
          ),
        ),
        child: Obx(() {
          final currentUser = authController.currentUser;
          if (authController.isLoading || currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFffd60a).withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0f1419),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement du profil...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (_isEditing) {
            return _buildEditForm(currentUser);
          } else {
            return _buildViewProfile(currentUser);
          }
        }),
      ),
    );
  }

  Widget _buildViewProfile(UserModel user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 28),
            _buildDetailCard('Nom', user.name, Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildDetailCard('Email', user.email, Icons.mail_outline_rounded),
            const SizedBox(height: 12),
            if (user.role == 'client') ...[
              _buildDetailCard(
                'Adresse',
                user.client?.address ?? 'Non renseigné',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Téléphone',
                user.client?.phone ?? 'Non renseigné',
                Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
            ],
            if (user.role == 'technician') ...[
              // Logo section for technician
              if (user.technician?.logo != null &&
                  user.technician!.logo!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFffd60a,
                              ).withValues(alpha: 0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Logo de la société',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.5),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFffd60a),
                                      Color(0xFFffc300),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    user.technician!.logo!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.business,
                                        size: 40,
                                        color: Color(0xFF0f1419),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFffd60a,
                              ).withValues(alpha: 0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Logo de la société',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.5),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFffd60a),
                                      Color(0xFFffc300),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.business,
                                  size: 40,
                                  color: Color(0xFF0f1419),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Nom de la société',
                user.technician?.companyName ?? 'Non renseigné',
                Icons.business_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Adresse',
                user.technician?.address ?? 'Non renseigné',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Téléphone',
                user.technician?.phone ?? 'Non renseigné',
                Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Certificats',
                user.technician?.certificates ?? 'Non renseigné',
                Icons.verified_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Expérience',
                user.technician?.experience ?? 'Non renseigné',
                Icons.star_outline_rounded,
              ),
              const SizedBox(height: 12),
            ],
            if (user.role == 'owner') ...[
              _buildDetailCard(
                'Nom de la société',
                user.owner?.companyName ?? 'Non renseigné',
                Icons.business_outlined,
              ),
              const SizedBox(height: 12),
              _buildDetailCard(
                'Statut de licence',
                user.owner?.licenseStatus?.toString() ?? 'Non renseigné',
                Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 28),
            _buildActionButton(
              onPressed: () {
                _startEditing(user);
              },
              text: 'Modifier le profil',
              color: const Color(0xFFffd60a),
            ),
            const SizedBox(height: 10),
            _buildActionButton(
              onPressed: () {
                authController.logout();
              },
              text: 'Déconnexion',
              color: const Color(0xFFff6b6b),
              isSecondary: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(UserModel user) {
    _initializeControllers(user);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 28),
            _buildFormTextField(
              'Nom',
              _nameController,
              Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildFormTextField(
              'Email',
              _emailController,
              Icons.mail_outline_rounded,
              enabled: false,
            ),
            const SizedBox(height: 12),
            if (user.role == 'client') ...[
              _buildFormTextField(
                'Adresse',
                _addressController,
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Téléphone',
                _phoneController,
                Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
            ],
            if (user.role == 'technician') ...[
              // Logo section for technician in edit mode
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logo de la société',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: GestureDetector(
                              onTap: _pickLogoImage,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFffd60a),
                                      Color(0xFFffc300),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (user.technician?.logo != null &&
                                        user.technician!.logo!.isNotEmpty &&
                                        _selectedImagePath == null)
                                      ClipOval(
                                        child: Image.network(
                                          user.technician!.logo!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.business,
                                                  size: 40,
                                                  color: Color(0xFF0f1419),
                                                );
                                              },
                                        ),
                                      )
                                    else if (_selectedImagePath != null)
                                      ClipOval(
                                        child: Image.file(
                                          File(_selectedImagePath!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.business,
                                        size: 40,
                                        color: Color(0xFF0f1419),
                                      ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Nom de la société',
                _companyNameController,
                Icons.business_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Adresse',
                _addressController,
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Téléphone',
                _phoneController,
                Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Certificats',
                _certificatesController,
                Icons.verified_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Expérience',
                _experienceController,
                Icons.star_outline_rounded,
              ),
              const SizedBox(height: 12),
            ],
            if (user.role == 'owner') ...[
              _buildFormTextField(
                'Nom de la société',
                _companyNameController,
                Icons.business_outlined,
              ),
              const SizedBox(height: 12),
              _buildFormTextField(
                'Statut de licence',
                _licenseStatusController,
                Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    onPressed: _saveProfile,
                    text: 'Enregistrer',
                    color: const Color(0xFFffd60a),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    onPressed: _cancelEditing,
                    text: 'Annuler',
                    color: const Color(0xFF00d4ff),
                    isSecondary: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildActionButton(
              onPressed: () {
                authController.logout();
              },
              text: 'Déconnexion',
              color: const Color(0xFFff6b6b),
              isSecondary: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffd60a).withValues(alpha: 0.12),
                const Color(0xFFffc300).withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Show logo for technician, otherwise show default avatar
              if (user.role == 'technician' &&
                  user.technician?.logo != null &&
                  user.technician!.logo!.isNotEmpty)
                GestureDetector(
                  onTap: _isEditing ? _pickLogoImage : null,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFffd60a).withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        user.technician!.logo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                              ),
                            ),
                            child: const Icon(
                              Icons.business,
                              size: 50,
                              color: Color(0xFF0f1419),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              else if (user.role == 'technician')
                GestureDetector(
                  onTap: _isEditing ? _pickLogoImage : null,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFffd60a).withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Icon(
                          Icons.business,
                          size: 50,
                          color: Color(0xFF0f1419),
                        ),
                        if (_isEditing)
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFffd60a).withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: Color(0xFF0f1419),
                  ),
                ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFffd60a).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFffd60a),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFffd60a).withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFffd60a).withValues(alpha: 0.15),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFFffd60a)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1a1f2e).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 4,
              right: 12,
              top: 2,
              bottom: 2,
            ),
            child: Container(
              color: WidgetStateColor.transparent,
              child: TextField(
                controller: controller,
                enabled: enabled,
                style: const TextStyle(
                  color: Color.fromARGB(255, 38, 38, 38),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Entrez $label',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: const Color(0xFFffd60a).withValues(alpha: 0.7),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: isSecondary
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSecondary ? color : const Color(0xFF0f1419),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  void _initializeControllers(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;

    if (user.role == 'client') {
      _addressController.text = user.client?.address ?? '';
      _phoneController.text = user.client?.phone ?? '';
    } else if (user.role == 'technician') {
      _companyNameController.text = user.technician?.companyName ?? '';
      _addressController.text = user.technician?.address ?? '';
      _phoneController.text = user.technician?.phone ?? '';
      _certificatesController.text = user.technician?.certificates ?? '';
      _experienceController.text = user.technician?.experience ?? '';
    } else if (user.role == 'owner') {
      _companyNameController.text = user.owner?.companyName ?? '';
      _licenseStatusController.text =
          user.owner?.licenseStatus?.toString() ?? '';
    }
  }

  bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(
      r'^[\+]?[\d]{1,4}?[\s\-\.]?[\(]?[\d]{1,3}[\)]?[\s\-\.]?[\d]{1,4}[\s\-\.]?[\d]{1,9}$',
    );
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d\+\s\-\.\(\)]'), '');
    String digitsOnly = cleanPhone.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 7) {
      return false;
    }
    return phoneRegex.hasMatch(cleanPhone);
  }

  void _startEditing(UserModel user) {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _saveProfile() async {
    final user = authController.currentUser;
    if (user == null) return;

    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Le nom est requis',
        backgroundColor: const Color(0xFFff6b6b),
        colorText: Colors.white,
      );
      return;
    }

    final Map<String, dynamic> profileData = {
      'name': _nameController.text.trim(),
    };

    if (user.role == 'client') {
      final String phone = _phoneController.text.trim();
      if (phone.isNotEmpty && !isValidPhoneNumber(phone)) {
        Get.snackbar(
          'Erreur',
          'Numéro de téléphone invalide',
          backgroundColor: const Color(0xFFff6b6b),
          colorText: Colors.white,
        );
        return;
      }
      profileData.addAll({
        'address': _addressController.text.trim(),
        'phone': phone,
      });
    } else if (user.role == 'technician') {
      final String phone = _phoneController.text.trim();
      if (phone.isNotEmpty && !isValidPhoneNumber(phone)) {
        Get.snackbar(
          'Erreur',
          'Numéro de téléphone invalide',
          backgroundColor: const Color(0xFFff6b6b),
          colorText: Colors.white,
        );
        return;
      }
      profileData.addAll({
        'company_name': _companyNameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': phone,
        'certificates': _certificatesController.text.trim(),
        'experience': _experienceController.text.trim(),
      });
    } else if (user.role == 'owner') {
      dynamic licenseStatusValue = _licenseStatusController.text.trim();
      if (_licenseStatusController.text.toLowerCase() == 'true' ||
          _licenseStatusController.text.toLowerCase() == 'active') {
        licenseStatusValue = true;
      } else if (_licenseStatusController.text.toLowerCase() == 'false' ||
          _licenseStatusController.text.toLowerCase() == 'inactive') {
        licenseStatusValue = false;
      }
      profileData.addAll({
        'company_name': _companyNameController.text.trim(),
        'license_status': licenseStatusValue,
      });
    }

    await authController.updateProfile(profileData);

    // Upload logo if selected for technician
    if (user.role == 'technician' && _selectedImagePath != null) {
      await authController.uploadProfileImage(_selectedImagePath!);
      _selectedImagePath = null; // Reset the selected image path
    }

    if (!authController.isLoading) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  Future<void> _pickLogoImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      _selectedImagePath = image.path;
      Get.snackbar(
        'Logo sélectionné',
        'Le logo sera mis à jour après l\'enregistrement',
        backgroundColor: const Color(0xFF00d4ff),
        colorText: Colors.white,
      );
      setState(() {});
    }
  }
}
