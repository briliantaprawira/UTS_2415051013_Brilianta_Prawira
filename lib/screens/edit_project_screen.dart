import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;
  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _conceptController;
  late int _priority;
  late String _status;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data proyek yang sudah ada
    _titleController = TextEditingController(text: widget.project.title);
    _conceptController = TextEditingController(text: widget.project.concept);
    _priority = widget.project.priority;
    _status = widget.project.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final updatedProject = ProjectModel(
        id: widget.project.id,
        title: _titleController.text,
        concept: _conceptController.text,
        priority: _priority,
        status: _status,
      );

      try {
        await Provider.of<ProjectProvider>(context, listen: false).updateProject(updatedProject);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proyek berhasil diperbarui!')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Proyek')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Proyek', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conceptController,
                decoration: const InputDecoration(labelText: 'Konsep', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Prioritas', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 - Santai')),
                  DropdownMenuItem(value: 2, child: Text('2 - Menengah')),
                  DropdownMenuItem(value: 3, child: Text('3 - Mendesak')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status Pengerjaan', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Sketsa', child: Text('Sketsa')),
                  DropdownMenuItem(value: 'Proses', child: Text('Proses')),
                  DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isSubmitting ? null : _submitData,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Perbarui Proyek', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}