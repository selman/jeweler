require 'yaml'
require 'erb'

PLUGIN_PATH  = File.expand_path('../plugins', __FILE__)
PLUGIN_FILES = Dir["#{PLUGIN_PATH}/**/*.yml"]

class Plugin
  def initialize opts = nil
    if opts
      opts.each_pair do |k, v|
        instance_variable_set(('@' + k).to_sym, v)
        self.class.send :attr_reader, k
      end
    end
  end

  def self.generate args=[], opts={}
    @@templates = {}
    @@development_dependencies = []

    args.each do |file|
      file_path = PLUGIN_FILES.select { |s| s =~ %r/.*\/#{file}\.yml$/ }.first

      templates = YAML::load( File.open(file_path))
      development_dependencies = templates['development_dependencies']
      templates.delete('development_dependencies')
      templates.delete_if {|k, v| k =~ /features.*/} unless args.include?("cucumber")
      
      @@templates[file.capitalize] = templates
      (@@development_dependencies += development_dependencies).uniq! if development_dependencies
    end
    new(opts)
  end

  def each
    context = eval 'binding'
    @@templates.values.each do |template|
      template.each_pair do |k, v|
        yield k, ERB.new(v).result(context)
      end
    end
  end

  def development_dependencies
    @@development_dependencies
  end

end
