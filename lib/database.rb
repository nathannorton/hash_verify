
require 'pp'
require 'rubygems' 
require 'socket'
require 'bson'
require 'mongo' 


module Database
  
  class << self ; attr_accessor :server, :port, :database ; end
  class << self ; attr_accessor :database, :collection ; end
  class << self ; attr_accessor :username, :password ; end

  @hostname = Socket.gethostname.split(".")[0]

  # set up the mongo DB connection, use defaults if 
  # the connection details in the config file are not set
  def self.setup_db( opts, auth )
    @port       = ( true && opts['port'] )       || 27017
    @server     = ( true && opts['server'] )     || 'localhost'
    @database   = ( true && opts['database'] )   || 'hash_verify'
    @collection = ( true && opts['collection'] ) || 'hashes'

    @username   = ( true && auth['username'] ) || 'hash_verify'
    @password   = ( true && auth['password'] ) || 'hash_password'

    db = Mongo::Connection.new( @server, @port ).db( @database )
    raise "Failed to authenticate against the db" \
      unless db.authenticate(username,password)

    @collection = db.collection( collection )
    db.strict = true
  end

  def self.publish_hash( hash, filename)
    doc = { "path" => filename,
            "host" => @hostname,
            "date" => Time.now,
            "algo" => hash.class.to_s,
            "hash" => hash.to_s}

    # check that the file is not already in the database
    unless contains?( filename ) 
      @collection.insert( doc )
      puts "The following file has been added to the hash collection: #{filename}"
    end
  end

  def self.publish_hashes( files ) 
    files.each do |k,v|
      publish_hash( v, k ) 
    end
  end

  def self.search_hashes(  path ) 
    @collection.find( "host" => @hostname , "path" => path).each {|row| return row}
    return nil 
  end


  def self.contains?(  path ) 
    @collection.find( "host" => @hostname , "path" => path).each {|row| return true}
    return false
  end

  def self.check_in_pub?( path, hash )
    @collection.find( "path" => path ).each do |row|
      pp row
      pp hash
      pp row.hash
      if hash.eql? row.hash 
        return true
      end
    end
    return false
  end

  def self.different_host?( path )
    @collection.find( "path" => path, "host" => @hostname ).each {|row| return false}
    return true
  end



end
