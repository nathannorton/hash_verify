
module Config

  class << self; attr_reader :action; end

	def self.clean_yaml( yaml )
	  raise "Connection setting no in config" unless yaml['connection']
	  raise "Auth section not in config " unless yaml['auth']
	  raise "Either action not in config" unless yaml['do_hash'] or yaml['verify'] 
	end
	
  # check if there is a transform for pub 
  def self.check_transform( yaml )
    transform = yaml['general']['pub_dir'] unless yaml['general']['pub_dir']
  end


	# in yaml: "y" "Y" "n" "N" get converted to strings 
	# not bools. "yes" "no" however do get passed as  bools 
	def self.convert_yaml_bools( str ) 
	  str.downcase! if str.class == String
	
	  return true  if str.eql? "y"
	  return false if str.eql? "n"
	
	  str
	end
	
	
	# Check the config is using a relatively sane 
	# set of values that will not break the script.
	def self.verify_config_dirs( option )
	  dir = option['directory']
	  rec = option['recursive']
	  act = option['action']
	
	  rec = convert_yaml_bools( rec ) 
	
	  bool = false
	  bool = true if rec.class == TrueClass or rec.class == FalseClass 
	
	  raise "Recursive field in config is not either \"y\" or \"n\"" unless bool
	  raise "You have specified a file that does not exist, exiting" unless File.file? dir or File.directory? dir
	  raise "You have selected recursive in the config, however you supplied a normal file, exiting" if rec and File.file? dir
	
	  valid_actions = ['delete','none','script','notify']
	  unless act.nil?
	    raise "action is not valid" unless valid_actions.include? act
	    @action = act
	  end
	
	  return true if rec == false and File.directory? dir
	  return true if rec == false and File.file? dir 
	  return true if rec and File.directory? dir
	  raise "Invalid config file, plese check and try again"
	end
	

end
