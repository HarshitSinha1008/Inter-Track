import 'package:flutter/material.dart';
import 'package:interntrack/services/internship_service.dart';
import '../models/internship_models.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

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

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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
            Image.asset('assets/logo.png', height: 30),
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

      body: Column(
        children: [
          // search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by company or role',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // filter list goes here
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Applied', 'Interview', 'Offer', 'Rejected']
                .map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                        ? const Color(0xFF1B2B4B)
                        : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                          ? const Color(0xFF1B2B4B)
                          : Colors.grey.shade300),
                      ),
                      child: Text(filter,
                        style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                          ? Colors.white
                          : Colors.grey.shade600)),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // internship list
            Expanded(
              child: _filteredInternships.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.work_outline,
                            size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No internships found',
                            style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredInternships.length,
                      itemBuilder: (context, index) {
                        final internship = _filteredInternships[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(internship: internship),
                              ),
                            );
                            if (result == true) _loadInternships(); 
                          } ,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(internship.companyName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(internship.role,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600)),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Applied: ${internship.dateApplied.day} ${_monthName(internship.dateApplied.month)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400)),
                                    ],
                                  ),
                                ),
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(internship.status)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(internship.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _statusColor(internship.status))),
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

      // + button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B2B4B),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditScreen()),
          );
          if (result == true) _loadInternships();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}