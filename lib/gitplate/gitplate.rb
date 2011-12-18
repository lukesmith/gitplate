require 'Git'

module Gitplate

  VERSION = "0.0.1"

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
    end

    # pull in the plate file from the cloned repository
    plate = File.expand_path(File.join(name, 'plate'))
    if (File.exists?(plate))
      Gitplate::Plate.instance.run(
          plate,
          :project_name => name,
          :project_dir => File.expand_path(name))
    else
      debug_msg "no plate file found in repository"
    end

    g = Git.open name
    g.add
    g.commit "Initial commit"
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