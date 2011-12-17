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

    def add_message(msg)
      foo = Proc.new { puts msg }
      add_action &foo
    end

    def add_custom(&block)
      add_action &block
    end

    def add_rename(from = nil, to = nil)
      foo = Proc.new { File.rename from, to }
      add_action &foo
    end

    def add_action(&action)
      @actions << action
    end

    def run
      @actions.each do |action|
        action.call
      end
      puts "You got fasfhasifhoahao."
    end
  end

end

def message(msg)
  Gitplate::Plate.instance.add_message msg
end

def custom(&block)
  Gitplate::Plate.instance.add_custom &block
end

def rename(from, to)
  Gitplate::Plate.instance.add_rename from, to
end