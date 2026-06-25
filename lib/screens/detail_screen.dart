import 'package:flutter/material.dart';
import 'package:interntrack/models/internship_models.dart';
import 'package:interntrack/services/internship_service.dart';

class DetailScreen extends StatefulWidget {

  final InternshipModel internship;
  const DetailScreen({super.key, required this.internship});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

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
      await InternshipService().deleteInternship(widget.internship.id);
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
            Center(child: Text(widget.internship.companyName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            // role
            Center(child: Text(widget.internship.role, style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 16),
            // status and date applied
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _statusColor(widget.internship.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.internship.status, style: TextStyle(
                    color: _statusColor(widget.internship.status),
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
          ],
        ),
      ),     
    );
  }
}