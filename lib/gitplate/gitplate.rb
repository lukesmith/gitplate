module Gitplate

  VERSION = "0.0.1"

  def self.execute_command(tool, args)
    args.flatten!

    puts "  ./#{tool.to_s} #{args[1..-1].join(' ')}".color(:cyan).bright
    system args.join ' '
  end

  def self.install
    puts "fasfas"
  end
  
end