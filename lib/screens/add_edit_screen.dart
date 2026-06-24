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
    );
  }
}