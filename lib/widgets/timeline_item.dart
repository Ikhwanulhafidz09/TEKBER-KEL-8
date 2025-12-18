import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final bool active;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    this.active = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color dotColor = active ? const Color(0xFF2F3E75) : Colors.grey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ==== TIMELINE (DOT + LINE) ====
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80, // ini bikin garis NYAMBUNG
                color: Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 16),

        /// ==== CONTENT ====
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE + TIME
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: active
                              ? const Color(0xFF2F3E75)
                              : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// DESCRIPTION
                Text(
                  desc,
                  style: TextStyle(
                    color: active ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}