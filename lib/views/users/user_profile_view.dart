import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:sunwinners/data/models/user_model.dart';

class UserProfileView extends StatelessWidget {
  final UserModel user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil de ${user.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 28),
                _buildDetailCard(
                  'Nom',
                  user.name,
                  Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                _buildDetailCard(
                  'Email',
                  user.email,
                  Icons.mail_outline_rounded,
                ),
                const SizedBox(height: 12),
                _buildDetailCard(
                  'Rôle',
                  user.role.toUpperCase(),
                  Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                if (user.role == 'client') ...[
                  if (user.client?.address != null &&
                      user.client!.address!.isNotEmpty)
                    _buildDetailCard(
                      'Adresse',
                      user.client!.address!,
                      Icons.location_on_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.client?.phone != null &&
                      user.client!.phone!.isNotEmpty)
                    _buildDetailCard(
                      'Téléphone',
                      user.client!.phone!,
                      Icons.phone_outlined,
                    )
                  else
                    const SizedBox.shrink(),
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                  if (user.technician?.companyName != null &&
                      user.technician!.companyName!.isNotEmpty)
                    _buildDetailCard(
                      'Nom de la société',
                      user.technician!.companyName!,
                      Icons.business_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.technician?.address != null &&
                      user.technician!.address!.isNotEmpty)
                    _buildDetailCard(
                      'Adresse',
                      user.technician!.address!,
                      Icons.location_on_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.technician?.phone != null &&
                      user.technician!.phone!.isNotEmpty)
                    _buildDetailCard(
                      'Téléphone',
                      user.technician!.phone!,
                      Icons.phone_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.technician?.certificates != null &&
                      user.technician!.certificates!.isNotEmpty)
                    _buildDetailCard(
                      'Certificats',
                      user.technician!.certificates!,
                      Icons.verified_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.technician?.experience != null)
                    _buildDetailCard(
                      'Expérience',
                      '${user.technician!.experience} ans',
                      Icons.star_outline_rounded,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                ],
                if (user.role == 'owner') ...[
                  if (user.owner?.companyName != null &&
                      user.owner!.companyName!.isNotEmpty)
                    _buildDetailCard(
                      'Nom de la société',
                      user.owner!.companyName!,
                      Icons.business_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  if (user.owner?.licenseStatus != null)
                    _buildDetailCard(
                      'Statut de licence',
                      user.owner!.licenseStatus.toString(),
                      Icons.badge_outlined,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
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
                Container(
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
                )
              else if (user.role == 'technician')
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
                    Icons.business,
                    size: 50,
                    color: Color(0xFF0f1419),
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
}
