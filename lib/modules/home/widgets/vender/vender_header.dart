import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/vender_home_controller.dart';

class VenderHeader extends GetView<VenderController> {
  const VenderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        image: const DecorationImage(
          image: NetworkImage(
            'https://cdn.5280.com/2014/11/Aspen%20FINAL%20Interior%20Render.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 16),
                      _buildProfileDetails(),
                      _buildNotificationButton(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildGlassBalanceCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
      ),
      child: CircleAvatar(
        backgroundImage: controller.userImageUrl.value.isNotEmpty
            ? NetworkImage(controller.userImageUrl.value)
            : null,
        child: controller.userImageUrl.value.isEmpty ? const Icon(Icons.person) : null,
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${controller.greeting} 👋',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),

          Text(controller.userName.value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),

          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
              const SizedBox(width: 4),
              Text('4.8',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              Text(' (1,284)',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFF1DBF73),
                    borderRadius: BorderRadius.circular(14)),
                child: const Text('Verified',
                    style: TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications_none_rounded,
              color: Colors.white, size: 30),
          Positioned(
            top: 14,
            right: 14,
            child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBalanceCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Balance',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.75), fontSize: 15)),
                    const SizedBox(height: 12),
                    Text('\$${controller.availableBalance.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                        'Pending: \$${controller.pendingBalance.value.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.75), fontSize: 15)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: controller.onWithdrawTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),
                icon: const Icon(Icons.file_download_outlined, size: 24),
                label: const Text('Withdraw',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}