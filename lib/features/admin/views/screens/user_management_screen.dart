import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/core/models/user_role.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text(
          'USER ROLE MANAGEMENT',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandOrange),
            );
          }

          final users = snapshot.data!.docs.map((doc) {
            return UserRole.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No users found in database.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserTile(context, user)
                  .animate()
                  .fadeIn(delay: (index * 50).ms)
                  .slideX(begin: 0.1, end: 0);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserRole user) {
    final isAdmin = user.role == 'admin';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isAdmin ? AppColors.brandOrange : Colors.grey[800],
            child: Text(
              user.email.isNotEmpty ? user.email[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Joined: ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildRoleBadge(user.role),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () => _showRoleDialog(context, user),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isAdmin ? AppColors.brandOrange : Colors.blue).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isAdmin ? AppColors.brandOrange : Colors.blue).withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: isAdmin ? AppColors.brandOrange : Colors.blue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, UserRole user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Update User Role',
          style: TextStyle(color: Colors.white),
        ),
        content: RadioGroup<String>(
          groupValue: user.role,
          onChanged: (value) => _updateRole(context, user.uid, value!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'User',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: 'user',
                  activeColor: AppColors.brandOrange,
                ),
              ),
              ListTile(
                title: const Text(
                  'Admin',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: 'admin',
                  activeColor: AppColors.brandOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateRole(
    BuildContext context,
    String uid,
    String newRole,
  ) async {
    Navigator.pop(context);
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'role': newRole,
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User role updated to $newRole')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating role: $e')));
      }
    }
  }
}
