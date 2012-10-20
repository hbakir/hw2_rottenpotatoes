class Movie < ActiveRecord::Base
  def self.all_ratings
    result = []
    Movie.find_by_sql("SELECT DISTINCT(m.rating) FROM movies m").each {|movie| result << movie.rating}
    result
  end
end
