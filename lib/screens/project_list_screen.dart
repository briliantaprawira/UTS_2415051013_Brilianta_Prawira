import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import 'add_project_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          // 1. Loading State
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadProjects,
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }

          // 3. Empty State
          if (provider.projects.isEmpty) {
            return const Center(child: Text('Belum ada proyek desain.\nYuk buat yang baru!', textAlign: TextAlign.center));
          }

          // 4. Success State (Data terisi)
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${project.concept} • Prioritas: ${project.priority}'),
                  trailing: Chip(
                    label: Text(project.status, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.deepPurple.withOpacity(0.2),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pindah ke halaman form tambah data
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}