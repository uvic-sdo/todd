module Todd
  class Base
    include Singleton

    def self.setup
      self.instance
    end

    def self.[](key)
      @__instance__.config[key]
    end

    attr_reader :config

    def initialize
      @config = {
        :default_db_path    => "/home/carl/dev/todd/test.db",
        :config_filename    => ".todd",
        :default_category   => "default",
        :default_config     => "todd_hash: %s\n",
        :output_format      => "minimal"
      }

      if File.exists? @config[:config_filename]
        begin
          conf = YAML.load(File.open(@config[:config_filename], 'r').read)
          conf.each { |key, val|
            @config[key.to_sym] = val
          } unless conf == nil
        rescue scripterror => e
          warn("error reading #{@config[:config_filename]}, you might have an error in your local .todd file.")
          puts "exception trace:"
          pp e
          exit
        end
      else
        unless ARGV.include? "init"
          warn("Error finding #{@config[:config_filename]}")
          warn("If you want to use Todd in this dir, please run todd init")
          exit
        end
      end
    end

    def self.init_local_dir
      if File.exists? self[:config_filename]
        warn "Todd is already initialized in the local directory"
        return
      end

      current_dir = Dir.getwd
      current_dir_md5 = Digest::MD5.hexdigest(current_dir)
      
      TodoList.create(:md5_id => current_dir_md5)

      File.open(self[:config_filename], 'w') do |f|
        f.write(sprintf(self[:default_config], current_dir_md5))
      end

      puts "Initialized Todd in #{current_dir}"
    end

    def self.set_formatting format
      @__instance__.config[:output_format] = format
    end
  end
end
