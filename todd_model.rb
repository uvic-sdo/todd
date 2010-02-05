require 'rubygems'
require 'dm-core'

# Setup DataMapper

DataMapper.setup(:default, 'sqlite3::memory:')


class Category
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :created_at,   DateTime,   :default => DateTime.new
end

class Task
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String
  property :notes,        Text
  property :created_at,   DateTime,   :default => DateTime.new
  property :deleted,      Boolean,    :default => false
  property :deleted_at,   DateTime,   :default => DateTime.new
  
  belongs_to :category
end
