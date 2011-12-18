require 'Git'
require 'zip/zip'

module Gitplate

  VERSION = "0.0.2"

  def self.config_file
    "#{gitplate_dir}/config.yml"
  end

  def self.plate_file
    "#{gitplate_dir}/plate"
  end

  def self.gitplate_dir
    '.gitplate'
  end

  def self.init
    init_gitplate_dir

    if (!File.exists?(plate_file))
      debug_msg "Creating sample plate file #{plate_file}"

      # create the sample plate file
      File.open(plate_file, "w") { |f|
        f.write("init do\n")
        f.write("  # add code to run when installing a new project\n")
        f.write("end\n")
      }
    end
  end

  def self.get_plate_repository(project_name, repository)
    source_repository_sha = ""

    Dir.chdir project_name do
      # create a gitplate directory structure for checking out the repository to
      out_path = File.expand_path(File.join(gitplate_dir, 'tmp', 'checkout'))
      FileUtils.mkdir_p out_path

      archive_file = File.expand_path(File.join(gitplate_dir, 'tmp', "#{project_name}.zip"))

      Dir.chdir out_path do
        source_repository = Git.clone(repository, project_name)
        source_repository_sha = source_repository.object('HEAD').sha

        source_repository.archive(source_repository_sha, archive_file, :format => "zip")
      end

      unzip_file archive_file, Dir.pwd

      # get rid of the temporary directory
      clear_directory File.expand_path(File.join(gitplate_dir, 'tmp'))
    end

    source_repository_sha
  end

  def self.install(project_name, repository)
    if (File.directory? project_name)
      fatal_msg_and_fail "Directory already exists"
    end

    info_msg "creating #{project_name} based on #{repository}"

    FileUtils.mkdir_p project_name
    
    source_repository_sha = get_plate_repository(project_name, repository)

    # we've got the repository cloned and cleaned up of existing git history
    Dir.chdir project_name do
      ensure_gitplate_dir
      
      update_config_with({
          :project => { :name => project_name },
          :repository => { :url => repository, :sha => source_repository_sha }
        })

      # pull in the plate file from the cloned repository
      if (File.exists?(plate_file))
        Gitplate::Plate.instance.run(
            plate_file,
            {
              :project_name => project_name,
              :project_dir => Dir.pwd
            })
      else
        debug_msg "no plate file found in repository"
      end

      g = Git.init
      g.add
      g.commit "Initial commit"
    end
  end

  def self.task(task, args)
    config = load_gitplate_file

    Gitplate::Plate.instance.run_task(
        plate_file,
        task,
        {
          :project_name => config["project"]["name"],
          :project_dir => Dir.pwd
        })
  end

  def self.init_gitplate_dir(update_version = true)
    if (!File.directory? gitplate_dir)
      FileUtils.mkdir_p gitplate_dir
    end

    if (!File.exists?(config_file))
      debug_msg "Creating config file"
      File.open(config_file, 'w') { |f| YAML.dump({}, f) }
    end

    if (update_version)
      update_config_with({ :gitplate => { :init_version => Gitplate::VERSION } })
    end
  end

  def self.ensure_gitplate_dir
    init_gitplate_dir false
  end

  def self.load_gitplate_file
    YAML.load(File.open(config_file))
  end

  def self.update_config_with(values)
    config = load_gitplate_file

    formatted = format_hash_for_yaml values
    formatted.each do |name, value|
      config[name.to_s] = value
    end

    File.open(config_file, 'w') { |f| YAML.dump(config, f) }
  end

  def self.info_msg(msg)
    puts msg.color(:green).bright
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

  def self.format_hash_for_yaml(hash)
    result = Hash.new

    hash.each do |name, value|
      if (value.kind_of? Hash)
        result[name.to_s] = format_hash_for_yaml value
      else
        result[name.to_s] = value
      end
    end

    result
  end

  def self.unzip_file(file, destination)
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
     }
  }
end
  
end