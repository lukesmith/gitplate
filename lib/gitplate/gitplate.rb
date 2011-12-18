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

    info_msg "creating #{name} based on #{repository}"

    out_path = File.expand_path(File.join(name, 'tmp', 'checkout'))
    FileUtils.mkdir_p out_path
    
    source_repository = Git.clone(repository, name, :path => out_path)
    source_repository_sha = source_repository.object('HEAD').sha

    # move the repository files to the main directory
    files = Dir.glob("#{out_path}/#{name}/*") - [name]
    FileUtils.mkdir name unless File.directory? name
    FileUtils.cp_r files, name

    Dir.chdir name do
      # get rid of the temporary checkout directory
      clear_directory File.expand_path(File.join('tmp'))

      create_gitplate_file
      update_config_with({
          :project => { :name => name },
          :repository => { :url => repository, :sha => source_repository_sha },
          :gitplate_version => Gitplate::VERSION
        })

      # pull in the plate file from the cloned repository
      plate_file = 'plate'
      if (File.exists?(plate_file))
        Gitplate::Plate.instance.run(
            plate_file,
            {
              :project_name => name,
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
        'plate',
        task,
        {
          :project_name => config["project"]["name"],
          :project_dir => Dir.pwd
        })
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
  
end