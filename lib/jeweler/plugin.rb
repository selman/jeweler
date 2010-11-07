require 'yaml'
require 'erb'

PLUGIN_PATH  = File.expand_path('../plugins', __FILE__)
PLUGIN_FILES = Dir["#{PLUGIN_PATH}/**/*.yml"]

class Plugin
  def initialize opts = nil
    if opts
      opts.each_pair do |k,v|
        instance_variable_set(('@' + k).to_sym, v)
      end
    end
  end

  def self.generate args=[], opts={}
    plugins = []
    args.each do |file|
      file_path = PLUGIN_FILES.select { |s| s =~ %r/.*\/#{file}\.yml$/ }.first

      templates = YAML::load( File.open(file_path))
      development_dependencies = templates['development_dependencies']
      templates.delete('development_dependencies')
      templates.delete_if {|k, v| k =~ /features.*/} unless args.include?("cucumber")
      
      klass = Object.const_set(file.capitalize, Class.new(Plugin))
      klass.module_eval do
        @@templates ||= {}
        @@templates[file.capitalize] = templates

        @@development_dependencies ||= []
        (@@development_dependencies += development_dependencies).uniq! if development_dependencies
      end

      opts.keys.each do |k|
        klass.send :attr_reader, k
      end

      plugins << klass.new(opts)
    end
    plugins
  end

  def each
    context = eval 'binding'
    @@templates[self.class.name].each_pair do |k, v|
      yield k , ERB.new(v).result(context)
    end
  end

  def development_dependencies
    @@development_dependencies
  end

end
