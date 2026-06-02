
import 'package:flutter/material.dart';

class VenderAccountMenu extends StatelessWidget {
  const VenderAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.analytics_outlined, color: Color(0xFF10B981)),
            title: const Text('Sales Revenue Analytics', style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFF10B981)),
            title: const Text('Products Inventory Manager', style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}