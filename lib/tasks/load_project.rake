

desc 'creates a poject object from the project directory'

  task :project_load, [:project_name] => :environment do |task, args|
    project_file_path = Rails.root.join('project', args[:project_name], 'project.rb')

    load project_file_path
    project = Project.find_or_create_by title: Specific_project[:title]
    project.update({
      summary: Specific_project[:summary],
      organizations: Specific_project[:organizations] ,
      team: Specific_project[:team],
      pages: []
    })

    puts "Project: Created '#{project.title}'"

    # Load pages from content/*:
    content_path = Rails.root.join('project', args[:project_name], 'content')
    Dir.foreach(content_path).each do |file|
      path = Rails.root.join content_path, file
      next if File.directory? path

      ext = file[(0...file.index('.'))]
      page_key = file.split('.').first
      name = page_key.capitalize
      content = File.read path

      puts "  Loading page: \"#{name}\" (#{content.size}b)"
      if page_key == 'home'
        project.home_page_content = content

      else
        project.pages << {
          key: page_key,
          name: name,
          content: content
        }
      end
    end

    project.save

    Rake::Task['project_setup'].invoke(args[:project_name])
    # binding.pry
  end