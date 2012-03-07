#!/usr/bin/env ruby
# 
# 

# TODO: catch file exceptions 
# TODO: make sure @algo is valid for sha and md5 only!

require 'digest/md5'

module Hasher 
  # buffer for maximum size to chunk the hashing, in order to not 
  # kill my  machine by loading a many gig file into memory
  $BUF = 1024 * 1024 * 1024
  
  class << self ; attr_accessor :algo ; end

  @algo = Digest::MD5

  def self.generate_hashes( file_list ) 
    list = {}
    file_list.each do |path|
      hash = generate_hash( path )  
      list[path] = hash
    end
    list
  end

  def self.generate_hash( file ) 
    return generate_hash_md5( file )  if @algo == Digest::MD5 
    return generate_hash_sha2( file ) if @algo == Digest::SHA256
  end

  def self.generate_hash_md5( file )
    file_h = Digest::MD5.new
    File.open(file, 'rb') do |fh|
      while buffer = fh.read($BUF)
        file_h.update( buffer )
      end
    end
    file_h
  end

  def self.generate_hash_sha2( file )
    file_h = Digest::SHA256.new
    File.open(file, 'rb') do |fh|
      while buffer = fh.read($BUF)
        file_h.update( buffer )
      end
    end
    file_h
  end

end



