import 'package:flutter/material.dart';
import 'package:interntrack/services/internship_service.dart';
import '../models/internship_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<InternshipModel> _internships = [];

  @override
  void initState() {
    super.initState();
    _loadInternships();
  }

  void _loadInternships() {
    setState(() {
      _internships = InternshipService().getAllInternships();
    });
  }

  List<InternshipModel> get _filteredInternships {
    return _internships.where((internship) {
      // Check filter match
      final matchesFilter = _selectedFilter == 'All' || internship.status == _selectedFilter;

      // Check search match
      final matchesSearch = 
        internship.companyName.toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
        internship.role.toLowerCase()
          .contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,  // ← add this
          children: [
            // logo
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            // app name
            const Text('Intern',
              style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
            const Text('Track',
              style: TextStyle(
              fontSize: 22,
              color: Color(0xFF1B2B4B))),
          ],
        ),
        actions: [
          // profile icon goes here, not in title Row
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}