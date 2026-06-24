import 'package:flutter/material.dart';
import 'package:interntrack/services/internship_service.dart';
import 'package:interntrack/models/internship_models.dart';

class AddEditScreen extends StatefulWidget {
  final InternshipModel? internship;
  const AddEditScreen({super.key, this.internship});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {

  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  String _selectedStatus = 'Applied';
  bool _isSaving = false;
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _monthName(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[month - 1];
}

  @override
  void initState() {
    super.initState();
    if (widget.internship != null) {
      _companyController.text = widget.internship!.companyName;
      _roleController.text = widget.internship!.role;
      _selectedStatus = widget.internship!.status;
      _selectedDate = widget.internship!.dateApplied;
      _notesController.text = widget.internship!.notes;
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // validating fields
    if (_companyController.text.isEmpty || _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final internship = InternshipModel(
      id: widget.internship?.id ?? DateTime.now().toString(),
      companyName: _companyController.text,
      role: _roleController.text,
      status: _selectedStatus,
      dateApplied: _selectedDate,
      notes: _notesController.text,
    );

    try {
      if (widget.internship != null) {
        await InternshipService().updateInternship(internship);
      } else {
        await InternshipService().addInternship(internship);
      }

      if (mounted) Navigator.pop(context, true);}
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save internship.')),
        );
      }finally {
        setState(() => _isSaving = false);
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
        title: Text(widget.internship != null ? 'Edit Internship' : 'Add Internship'),
        actions: [
          // save button
          TextButton(
            onPressed: _isSaving ? null : _save, 
            child: _isSaving
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Text('SAVE',
                  style: TextStyle(
                    color: Color(0xFF1B2B4B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
          )
          
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
        
              const Text(
                'Company Name',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // company name field
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
        
              const SizedBox(height: 16),
        
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // role field
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Role',
                ),
              ),
        
              const SizedBox(height: 16),
        
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // status field
              DropdownButtonFormField<String>(
                onChanged: (val) => setState(() => _selectedStatus = val!),
                value: _selectedStatus,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Applied',
                    child: Text('Applied'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Interview',
                    child: Text('Interview'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Offer',
                    child: Text('Offer'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Rejected',
                    child: Text('Rejected'),
                  ),
                ],
              ),
        
              const SizedBox(height: 16),
        
              const Text(
                'Date Applied',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // date applied field
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030)
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        '${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
        
              const SizedBox(height: 16),
        
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 8),
        
              // notes field
              TextField(
                controller: _notesController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
              ),  
            ]
          ),
        ),
      ),
    );
  }
}