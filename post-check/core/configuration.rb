require 'active_support/core_ext'
require 'yaml'

module Configuration
  def self.[](key)
    CONTENTS.fetch(key.to_sym)
  end
 
  private

  def self.parse_config!
    raw_config = {}
    Dir::foreach("#{ENV['ROOT']}/config") do |dir| 
      path = "#{ENV['ROOT']}/config/" + dir + "/" + ENV['DEMO_ENV'] + "_config.yml"
      raw_config.merge!(YAML.load_file(path)) if File.exist?(path)
    end
    raw_config.with_indifferent_access
  end

  CONTENTS = self.parse_config!
end
