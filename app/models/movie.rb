class Movie < ActiveRecord::Base
  def self.all_ratings
    result = []
    Movie.find_by_sql("SELECT DISTINCT(m.rating) FROM movies m ORDER BY m.rating").each { |movie| result << movie.rating }
    result
  end
  
  def self.filter_by_ratings(filter)
    Movie.where(:rating => filter)
  end
end
