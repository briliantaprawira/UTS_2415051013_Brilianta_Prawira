import '../models/project_model.dart';
import '../services/project_supabase_service.dart';

class ProjectRepository {
  final ProjectSupabaseService _service;

  ProjectRepository(this._service);

  Future<List<ProjectModel>> getProjects() => _service.fetchProjects();
  Future<ProjectModel> addProject(ProjectModel project) => _service.createProject(project);
  Future<void> editProject(int id, ProjectModel project) => _service.updateProject(id, project);
  Future<void> removeProject(int id) => _service.deleteProject(id);
}