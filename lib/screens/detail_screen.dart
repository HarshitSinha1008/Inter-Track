import 'package:flutter/material.dart';
import 'package:interntrack/models/internship_models.dart';
import 'package:interntrack/screens/add_edit_screen.dart';
import 'package:interntrack/services/internship_service.dart';

class DetailScreen extends StatefulWidget {

  final InternshipModel internship;
  const DetailScreen({super.key, required this.internship});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late InternshipModel _internship;

  @override
  void initState() {
    super.initState();
    _internship = widget.internship;
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Applied':
        return Colors.blue;
      case 'Interview':
        return Colors.amber;
      case 'Offer':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Internship'),
        content: const Text('Are you sure you want to delete this internship?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await InternshipService().deleteInternship(_internship.id);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // company name
            Center(child: Text(_internship.companyName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            // role
            Center(child: Text(_internship.role, style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _statusColor(_internship.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_internship.status, style: TextStyle(
                      color: _statusColor(_internship.status),
                      fontWeight: FontWeight.bold,)),
                  ),
                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                SizedBox(width: 6),
                Text('Date Applied: ${widget.internship.dateApplied.day} ${_monthName(widget.internship.dateApplied.month)} ${widget.internship.dateApplied.year}', style: TextStyle(color: Colors.grey),),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes', 
                    style: TextStyle(
                      fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    widget.internship.notes.isEmpty
                      ? 'No notes'
                      : widget.internship.notes,
                    style: TextStyle(
                      color: Colors.grey.shade600
                    )),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditScreen(
                      internship: _internship)),
                );
                if (result == true && mounted) {
                  setState(() {
                    _internship = InternshipService()
                        .getAllInternships()
                        .firstWhere((i) => i.id == _internship.id);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B4B),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('EDIT'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _delete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('DELETE'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}