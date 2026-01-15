import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/user_controller.dart';
import 'package:sunwinners/data/models/user_model.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';
import 'package:sunwinners/views/users/user_profile_view.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data after the widget is built and dependencies are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userController = Get.find<UserController>();
      userController.loadAllTechnicians();
      userController.loadAllClients();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF0f1419),
          appBar: SunwinnersAppBar(
            title: 'Gestion des Utilisateurs',
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            iconColor: const Color(0xFFffd60a),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a1f2e),
                  Color(0xFF0f1419),
                  Color(0xFF051628),
                ],
              ),
            ),
            child: Column(
              children: [
                // TabBar personnalisé
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(0),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.05),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFFffd60a),
                        unselectedLabelColor: Colors.white.withValues(
                          alpha: 0.6,
                        ),
                        indicatorColor: const Color(0xFFffd60a),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFffd60a),
                              width: 3,
                            ),
                          ),
                        ),
                        tabs: const [
                          Tab(text: 'Techniciens'),
                          Tab(text: 'Clients'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TechnicianManagementTab(userController: controller),
                      ClientManagementTab(userController: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TechnicianManagementTab extends StatelessWidget {
  final UserController userController;

  const TechnicianManagementTab({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.isLoading && controller.technicians.isEmpty) {
          return Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFffd60a),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0f1419)),
                strokeWidth: 3,
              ),
            ),
          );
        }

        if (controller.technicians.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.engineering_outlined,
                    size: 40,
                    color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Aucun technicien trouvé',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadAllTechnicians(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView.builder(
              itemCount: controller.technicians.length,
              itemBuilder: (context, index) {
                final technician = controller.technicians[index];
                return _buildTechnicianCard(context, technician);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTechnicianCard(BuildContext context, UserModel technician) {
    final isApproved = technician.approved;

    return GestureDetector(
      onTap: () {
        Get.to(() => UserProfileView(user: technician));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.08),
                    Color.fromRGBO(255, 255, 255, 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.engineering,
                            color: const Color(0xFFffd60a),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                technician.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                technician.email,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isApproved)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 214, 10, 0.25),
                                  Color.fromRGBO(255, 214, 10, 0.12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFFffd60a,
                                ).withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'En attente',
                              style: const TextStyle(
                                color: Color(0xFFffd60a),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(0, 255, 136, 0.25),
                                  Color.fromRGBO(0, 255, 136, 0.12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF00ff88,
                                ).withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Approuvé',
                              style: const TextStyle(
                                color: Color(0xFF00ff88),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (technician.technician?.companyName != null)
                      _buildInfoRow(
                        'Entreprise',
                        technician.technician!.companyName!,
                      ),
                    if (technician.technician?.phone != null)
                      _buildInfoRow('Téléphone', technician.technician!.phone!),
                    if (technician.technician?.certificates != null)
                      _buildInfoRow(
                        'Certificats',
                        technician.technician!.certificates!,
                      ),
                    if (technician.technician?.experience != null)
                      _buildInfoRow(
                        'Expérience',
                        '${technician.technician!.experience} ans',
                      ),

                    const SizedBox(height: 12),
                    if (!isApproved)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFffd60a),
                                    Color(0xFFffc300),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFffd60a),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => userController.approveTechnician(
                                  technician.id,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Approuver',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1a1f2e),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFff6b6b),
                                    Color(0xFFff4d4d),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFff6b6b),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => userController.rejectTechnician(
                                  technician.id,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Rejeter',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientManagementTab extends StatelessWidget {
  final UserController userController;

  const ClientManagementTab({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.isLoading && controller.clients.isEmpty) {
          return Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFffd60a),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0f1419)),
                strokeWidth: 3,
              ),
            ),
          );
        }

        if (controller.clients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.people_outline,
                    size: 40,
                    color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Aucun client trouvé',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadAllClients(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView.builder(
              itemCount: controller.clients.length,
              itemBuilder: (context, index) {
                final client = controller.clients[index];
                return _buildClientCard(context, client);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientCard(BuildContext context, UserModel client) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserProfileView(user: client));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.08),
                    Color.fromRGBO(255, 255, 255, 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person,
                            color: const Color(0xFFffd60a),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                client.email,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (client.client?.address != null)
                      _buildInfoRow('Adresse', client.client!.address!),
                    if (client.client?.phone != null)
                      _buildInfoRow('Téléphone', client.client!.phone!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
