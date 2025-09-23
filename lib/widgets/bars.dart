import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int current;
  final int max;
  final IconData icon;
  final Color color;
  final double height;

  const StatBar({
    super.key,
    required this.label,
    required this.current,
    required this.max,
    required this.icon,
    required this.color,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final v = (current / (max == 0 ? 1 : max)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text("$label $current/$max", style: const TextStyle(fontSize: 12)),
        ]),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: v,
            minHeight: height,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class StatusCard extends StatelessWidget {
  final String name;
  final int hp, maxHp, cp, maxCp, sp, maxSp, ap, maxAp;
  final Widget? trailing;

  const StatusCard({
    super.key,
    required this.name,
    required this.hp,
    required this.maxHp,
    required this.cp,
    required this.maxCp,
    required this.sp,
    required this.maxSp,
    required this.ap,
    required this.maxAp,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700))),
            if (trailing != null) trailing!,
          ]),
          const SizedBox(height: 8),
          StatBar(label: "HP", current: hp, max: maxHp, icon: Icons.favorite, color: Colors.redAccent),
          const SizedBox(height: 8),
          StatBar(label: "CP", current: cp, max: maxCp, icon: Icons.auto_fix_high, color: Colors.lightBlueAccent),
          const SizedBox(height: 8),
          StatBar(label: "SP", current: sp, max: maxSp, icon: Icons.run_circle, color: Colors.lightGreenAccent),
          const SizedBox(height: 8),
          StatBar(label: "AP", current: ap, max: maxAp, icon: Icons.timelapse, color: Colors.amberAccent, height: 8),
        ],
      ),
    );
  }
}
