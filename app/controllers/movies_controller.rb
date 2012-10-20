class MoviesController < ApplicationController

  def initialize
    puts "calling MoviesController.initialize"
    super
    @all_ratings = Movie.all_ratings
    @filter = Hash.new
    @all_ratings.each { |rating| @filter[rating] = "1" }
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "calling MoviesController.index"
    puts "params = "
    puts params.inspect
    @sort = params[:sort]
    ratings = params[:ratings]
    if ratings == nil
      puts "ratings == nil => all movies"
      movies = Movie.all
    else
      puts "ratings NOT nil => filtered movies"
      puts "ratings.keys = "
      puts ratings.keys
      @filter = ratings
      movies = Movie.filter_by_ratings(ratings.keys)
    end
    if @sort == 'by_title'
      @movies = movies.sort { |a,b| a.title <=> b.title }
    elsif @sort == 'by_release_date'
      @movies = movies.sort_by &:release_date    
    else
      @movies = movies
    end
    puts "@filter = "
    puts @filter.inspect
    puts "@all_ratings = "
    puts @all_ratings.inspect
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
