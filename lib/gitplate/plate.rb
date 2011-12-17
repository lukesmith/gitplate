module Gitplate
  require 'singleton'

  class Plate
    include Singleton
    
    def initialize
      @actions = []
    end

    def self.actions
      @actions
    end

    def output(type, msg)
      instance = Gitplate::Outputs.const_get(to_class_name(type)).new
      instance.execute msg
    end

    def custom(&block)
      block.call
    end

    def rename(from = nil, to = nil)
      Gitplate.debug_msg "  renaming #{from} to #{to}"
      File.rename(expand_path(from), expand_path(to))
    end

    def project_name
      @project_name
    end

    def run(file, args)
      @project_name = args[:project_name]
      @project_dir = args[:project_dir]

      Gitplate.debug_msg "running plate - start"
      load file
      Gitplate.debug_msg "running plate - completed"
    end

    def to_class_name(type)
      type.to_s.split('_').map{|word| word.capitalize}.join
    end

    def expand_path(path)
      File.expand_path(File.join(@project_dir, path))
    end
  end

  module Outputs
    class Debug
      def execute(msg)
        puts msg.color(:cyan).bright
      end
    end

    class Fatal
      def execute(msg)
        puts msg.color(:red).bright
      end
    end
  end

end

def project_name
  Gitplate::Plate.instance.project_name
end

def output(type, msg)
  Gitplate::Plate.instance.output type, "  #{msg}"
end

def custom(&block)
  Gitplate::Plate.instance.custom &block
end

def rename(from, to)
  Gitplate::Plate.instance.rename from, to
end