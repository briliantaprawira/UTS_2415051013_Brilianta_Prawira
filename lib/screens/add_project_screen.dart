import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _conceptController = TextEditingController();
  int _priority = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final newProject = ProjectModel(
        title: _titleController.text,
        concept: _conceptController.text,
        priority: _priority,
        status: 'Sketsa', // Default awal
      );

      try {
        await Provider.of<ProjectProvider>(context, listen: false).addProject(newProject);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proyek berhasil ditambahkan!')));
          Navigator.pop(context); // Kembali ke daftar setelah sukses
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Proyek Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Proyek (ex: Logo Esports)', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Nama proyek tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conceptController,
                decoration: const InputDecoration(labelText: 'Konsep (ex: Minimalis, 3D)', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Konsep tidak boleh kosong' : null,
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
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isSubmitting ? null : _submitData,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Simpan Proyek', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}