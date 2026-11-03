import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository _repository;

  ProjectProvider(this._repository);

  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _repository.getProjects();
    } catch (e) {
      _error = 'Gagal memuat data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProject(ProjectModel project) async {
    try {
      final newProject = await _repository.addProject(project);
      _projects.add(newProject);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah proyek: $e');
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    if (project.id == null) return;
    try {
      await _repository.editProject(project.id!, project);
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = project;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Gagal memperbarui proyek: $e');
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _repository.removeProject(id);
      _projects.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus proyek: $e');
    }
  }
}