import 'dart:convert';

class Resume {
  String name;
  String contact;
  String summary;
  List<String> education;
  List<Experience> experience;
  List<Project> projects;
  List<String> skills;
  List<String> links;

  Resume({
    this.name = '',
    this.contact = '',
    this.summary = '',
    this.education = const [],
    this.experience = const [],
    this.projects = const [],
    this.skills = const [],
    this.links = const [],
  });

  // Helper to check for validation issues
  bool hasValidationWarnings() {
    return name.trim().isEmpty || (experience.isEmpty && projects.isEmpty);
  }

  // Generate plain-text version for copy export
  String toPlainText() {
    final buffer = StringBuffer();
    if (name.isNotEmpty) buffer.writeln('Name: $name');
    if (contact.isNotEmpty) buffer.writeln('Contact: $contact');
    if (summary.isNotEmpty) buffer.writeln('Summary: $summary');
    if (education.isNotEmpty) {
      buffer.writeln('Education:');
      for (final edu in education) buffer.writeln('  $edu');
    }
    if (experience.isNotEmpty) {
      buffer.writeln('Experience:');
      for (final exp in experience) {
        buffer.writeln('  ${exp.title} at ${exp.company} (${exp.duration})');
        for (final bullet in exp.bullets) buffer.writeln('    - $bullet');
      }
    }
    if (projects.isNotEmpty) {
      buffer.writeln('Projects:');
      for (final proj in projects) {
        buffer.writeln('  ${proj.title} (${proj.duration})');
        for (final bullet in proj.bullets) buffer.writeln('    - $bullet');
      }
    }
    if (skills.isNotEmpty) buffer.writeln('Skills: ${skills.join(', ')}');
    if (links.isNotEmpty) buffer.writeln('Links: ${links.join(', ')}');
    return buffer.toString();
  }

  // JSON serialization for persistence (if needed)
  Map<String, dynamic> toJson() => {
    'name': name,
    'contact': contact,
    'summary': summary,
    'education': education,
    'experience': experience.map((e) => e.toJson()).toList(),
    'projects': projects.map((p) => p.toJson()).toList(),
    'skills': skills,
    'links': links,
  };

  factory Resume.fromJson(Map<String, dynamic> json) => Resume(
    name: json['name'] ?? '',
    contact: json['contact'] ?? '',
    summary: json['summary'] ?? '',
    education: List<String>.from(json['education'] ?? []),
    experience: (json['experience'] as List<dynamic>? ?? []).map((e) => Experience.fromJson(e)).toList(),
    projects: (json['projects'] as List<dynamic>? ?? []).map((p) => Project.fromJson(p)).toList(),
    skills: List<String>.from(json['skills'] ?? []),
    links: List<String>.from(json['links'] ?? []),
  );
}

class Experience {
  String title;
  String company;
  String duration;
  List<String> bullets;

  Experience({
    this.title = '',
    this.company = '',
    this.duration = '',
    this.bullets = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'duration': duration,
    'bullets': bullets,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    title: json['title'] ?? '',
    company: json['company'] ?? '',
    duration: json['duration'] ?? '',
    bullets: List<String>.from(json['bullets'] ?? []),
  );
}

class Project {
  String title;
  String duration;
  List<String> bullets;

  Project({
    this.title = '',
    this.duration = '',
    this.bullets = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'duration': duration,
    'bullets': bullets,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    title: json['title'] ?? '',
    duration: json['duration'] ?? '',
    bullets: List<String>.from(json['bullets'] ?? []),
  );
}