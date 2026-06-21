import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  List<InternshipModel> get _filteredInternships() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InternTrack'),
      ),
    );
  }
}