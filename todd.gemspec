# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{todd}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carl Sverre"]
  s.date = %q{2010-02-22}
  s.description = %q{A simple time-tracking todo-list for the command line.}
  s.email = %q{carl@carlsverre.com}
  s.executables = ["todd", "todd.rb", "todd_old.rb"]
  s.extra_rdoc_files = ["TODO", "bin/todd", "bin/todd.rb", "bin/todd_old.rb", "lib/todd.rb", "lib/todd/config.rb", "lib/todd/model.rb", "lib/todd/util.rb", "lib/todd/version.rb", "tasks/enviroment.rake", "tasks/migrate.rake", "tasks/migration.rake", "tasks/revert.rake", "tasks/revert_db.rake"]
  s.files = ["History.md", "Manifest", "Rakefile", "Readme.md", "TODO", "bin/todd", "bin/todd.rb", "bin/todd_old.rb", "db/database.yml", "db/migrations/0214102019_initialize_database.rb", "db/migrations/0221102255_add_punch_table.rb", "db/migrations/0222102121_remove_archived_tasks.rb", "db/migrations/0222102124_add_archived_column_to_tasks.rb", "db/todd.db", "lib/todd.rb", "lib/todd/config.rb", "lib/todd/model.rb", "lib/todd/util.rb", "lib/todd/version.rb", "tasks/enviroment.rake", "tasks/migrate.rake", "tasks/migration.rake", "tasks/revert.rake", "tasks/revert_db.rake", "todd.gemspec"]
  s.homepage = %q{http://github.com/uvic-sdo/todd}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Todd", "--main", "Readme.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{todd}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple time-tracking todo-list for the command line.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, [">= 4.0.2"])
      s.add_runtime_dependency(%q<active_record>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<terminal_table>, [">= 1.4.2"])
      s.add_runtime_dependency(%q<json>, [">= 1.2.0"])
    else
      s.add_dependency(%q<commander>, [">= 4.0.2"])
      s.add_dependency(%q<active_record>, [">= 2.3.5"])
      s.add_dependency(%q<terminal_table>, [">= 1.4.2"])
      s.add_dependency(%q<json>, [">= 1.2.0"])
    end
  else
    s.add_dependency(%q<commander>, [">= 4.0.2"])
    s.add_dependency(%q<active_record>, [">= 2.3.5"])
    s.add_dependency(%q<terminal_table>, [">= 1.4.2"])
    s.add_dependency(%q<json>, [">= 1.2.0"])
  end
end
