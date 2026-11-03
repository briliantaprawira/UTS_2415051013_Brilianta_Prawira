import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project_model.dart';

class ProjectSupabaseService {
  final _supabase = Supabase.instance.client;
  final String _tableName = 'design_projects';

  // Read
  Future<List<ProjectModel>> fetchProjects() async {
    final data = await _supabase.from(_tableName).select().order('id');
    return (data as List).map((json) => ProjectModel.fromJson(json)).toList();
  }

  // Create
  Future<ProjectModel> createProject(ProjectModel project) async {
    final data = await _supabase.from(_tableName).insert(project.toJson()).select().single();
    return ProjectModel.fromJson(data);
  }

  // Update
  Future<void> updateProject(int id, ProjectModel project) async {
    await _supabase.from(_tableName).update(project.toJson()).eq('id', id);
  }

  // Delete
  Future<void> deleteProject(int id) async {
    await _supabase.from(_tableName).delete().eq('id', id);
  }
}