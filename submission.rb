require "data_mapper"

class Submission
  include DataMapper::Resource

  property :id, Serial
  property :name, String, length: 255
  property :suspect, String, length: 255
  property :weapon, String, length: 255
  property :comment, String, length: 1000
  property :success, Boolean
  property :submitted_at, DateTime
end
