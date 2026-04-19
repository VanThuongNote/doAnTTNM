import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/logo.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, dynamic>> _notes = [
    {'text': 'Hôm nay cảm thấy khỏe hơn, ít đau đầu', 'time': '10:30 AM', 'date': '12/04'},
    {'text': 'Uống thuốc Paracetamol lúc 8:00', 'time': '08:15 AM', 'date': '12/04'},
    {'text': 'Ngủ tốt đêm qua, khoảng 8 tiếng', 'time': '07:00 AM', 'date': '12/04'},
    {'text': 'Bị chóng mặt nhẹ sau khi tập thể dục', 'time': '18:00 PM', 'date': '11/04'},
    {'text': 'Thay đổi liều Ibuprofen theo chỉ dẫn bác sĩ', 'time': '14:00 PM', 'date': '11/04'},
  ];

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.insert(0, {
          'text': text,
          'time': '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
          'date': '12/04',
        });
        _noteController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('✅ Đã thêm ghi chú'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.monitor_heart, color: Colors.white, size: 20)),
                      const SizedBox(width: 10),
                      const Text('Ghi chú',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            // Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Input
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Viết ghi chú mới...',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.06),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _addNote,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Thêm ghi chú'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Notes list
                    Expanded(
                      child: ListView.separated(
                        itemCount: _notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final note = _notes[i];
                          return Dismissible(
                            key: Key('$i-${note['text']}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.danger.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: AppTheme.danger),
                            ),
                            onDismissed: (_) => setState(() => _notes.removeAt(i)),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(note['text'],
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.3), size: 14),
                                      const SizedBox(width: 4),
                                      Text('${note['date']} ${note['time']}',
                                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

