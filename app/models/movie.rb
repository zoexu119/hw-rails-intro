class Movie < ActiveRecord::Base
  def self.all_ratings
    pluck('DISTINCT rating').sort!
  end
end