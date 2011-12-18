require 'Git'

module Gitplate

  VERSION = "0.0.1"

  def self.config_file
    '.gitplate/config.yml'
  end

  def self.install(name, repository)
    if (File.directory? name)
      fatal_msg_and_fail "Directory already exists"
    end

    puts "creating #{name} based on #{repository}"

    out_path = File.expand_path(File.join(name, 'tmp', 'checkout'))
    FileUtils.mkdir_p out_path
    
    Git.clone(repository, name, :path => out_path)

    # move the repository files to the main directory
    files = Dir.glob("#{out_path}/#{name}/*") - [name]
    FileUtils.mkdir name unless File.directory? name
    FileUtils.cp_r files, name

    # get rid of the temporary checkout directory
    clear_directory File.expand_path(File.join(name, 'tmp'))

    Dir.chdir name do
      Git.init

      create_gitplate_file
      update_config_with :project_name, name
    end

    # pull in the plate file from the cloned repository
    plate_file = File.expand_path(File.join(name, 'plate'))
    if (File.exists?(plate_file))
      Gitplate::Plate.instance.run(
          plate_file,
          :project_name => name,
          :project_dir => File.expand_path(name))
    else
      debug_msg "no plate file found in repository"
    end

    g = Git.open name
    g.add
    g.commit "Initial commit"
  end

  def self.custom(task, args)
    config = load_gitplate_file

    project_dir = Dir.pwd
    plate_file = File.expand_path(File.join(project_dir, "plate"))

    Gitplate::Plate.instance.run_task(
        plate_file,
        task,
        :project_name => config["project_name"],
        :project_dir => project_dir)
  end

  def self.create_gitplate_file()
    FileUtils.mkdir_p '.gitplate'

    if (!File.exists?(config_file))
      File.open(config_file, 'w') { |f| YAML.dump({}, f) }
    end
  end

  def self.load_gitplate_file
    YAML.load(File.open(config_file))
  end

  def self.update_config_with(key, value)
    config = load_gitplate_file
    config[key.to_s] = value

    File.open(config_file, 'w') { |f| YAML.dump(config, f) }
  end

  def self.debug_msg(msg)
    puts msg.color(:cyan).bright
  end

  def self.fatal_msg(msg)
    puts msg.color(:red).bright
  end

  def self.fatal_msg_and_fail(msg)
    fatal_msg msg
    raise msg
  end

  def self.clear_directory(dir)
    if (File.directory?(dir))
      full_path = File.expand_path(dir)
      FileUtils.rm_rf full_path
    end
  end
  
end