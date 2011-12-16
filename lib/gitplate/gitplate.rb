require 'Git'

module Gitplate

  VERSION = "0.0.1"

  def self.execute_command(tool, args)
    args.flatten!

    puts "  ./#{tool.to_s} #{args[1..-1].join(' ')}".color(:cyan).bright
    system args.join ' '
  end

  def self.install(name, repository)
    if (File.directory? name)
      raise "Directory already exists"
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
  end

  def self.clear_directory(dir)
    if (File.directory?(dir))
      full_path = File.expand_path(dir)
      FileUtils.rm_rf full_path
    end
  end
  
end