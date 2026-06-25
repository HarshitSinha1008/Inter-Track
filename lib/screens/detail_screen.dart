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
      await InternshipService().deletePost(widget.internship.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}