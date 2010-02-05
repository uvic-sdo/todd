require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

# Setup DataMapper

def setup_db path = '/home/carl/dev/todd/test.db', adapter = 'sqlite3'
  DataMapper.setup(:default, adapter + '://' + path)
  begin
    File::Stat.new(path)
  rescue 
    DataMapper.auto_migrate!
  end
end

class Category
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String,     :required => true
  property :created_at,   DateTime
  property :updated_at,   DateTime

  has n, :tasks

  validates_is_unique :name
end

class Task
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String,     :required => true
  property :notes,        Text,       :default => ""
  property :created_at,   DateTime
  property :updated_at,   DateTime
  property :deleted,      ParanoidBoolean
  property :deleted_at,   ParanoidDateTime
  
  belongs_to :category
end

