module Gitplate
  require 'singleton'

  class Plate
    include Singleton

    def initialize
      @custom_tasks = Hash.new
    end

    def add_init(&block)
      if (@init != nil)
        Gitplate.fatal_msg_and_fail "Init can only be defined once"
      end

      Gitplate.debug_msg "  found init"
      @init = block
    end

    def add_custom_task(task_name, &block)
      Gitplate.debug_msg "  found custom task '#{task_name}'"
      @custom_tasks[task_name.to_s] = block
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

    def project_dir
      @project_dir
    end

    def run(file, args)
      load_plate file, args

      if (@init != nil)
        Gitplate.debug_msg "running plate - start"
        @init.call
        Gitplate.debug_msg "running plate - completed"
      end
    end

    def run_task(file, task_name, args)
      load_plate file, args

      task = @custom_tasks[task_name]

      if (task == nil)
        Gitplate.fatal_msg_and_fail "Unable to find custom task '#{task_name}'"
      end

      Gitplate.debug_msg "running task '#{task_name}' - start"
      task.call
      Gitplate.debug_msg "running task '#{task_name}' - completed"
    end

    def load_plate(file, args)
      @project_name = args[:project_name]
      @project_dir = args[:project_dir]
      
      #file = "/Users/lukesmith/Projects/gitplate/tmp/plate"

      Gitplate.debug_msg "loading plate from '#{file}'"
      load file
      Gitplate.debug_msg "loaded plate"
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

def init(&block)
  Gitplate::Plate.instance.add_init &block
end

def project_name
  Gitplate::Plate.instance.project_name
end

def project_dir
  Gitplate::Plate.instance.project_dir
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

def custom_task(task_name, &block)
  Gitplate::Plate.instance.add_custom_task task_name, &block
end