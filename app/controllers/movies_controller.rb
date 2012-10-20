class MoviesController < ApplicationController

  def initialize
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
    redirect = false
    # if one of them is null, and if it is not null in session, then redirect
    # first for :ratings
    if params[:ratings] == nil and session[:ratings] != nil
      params[:ratings] = session[:ratings]
      redirect = true
    end
    
    # second for :sort
    if params[:sort] == nil and session[:sort] != nil
      params[:sort] = session[:sort]
      redirect = true
    end
    
    if redirect
      # redirect with the params updated from the session
      redirect_to movies_path(params)
    else
      # update the session with the new params
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]

      # filter if needed
      if params[:ratings] == nil
        movies = Movie.all
      else
        @filter = params[:ratings]
        movies = Movie.filter_by_ratings(params[:ratings].keys)
      end

      # sort if needed
      @sort = params[:sort]
      if @sort == 'by_title'
        @movies = movies.sort { |a,b| a.title <=> b.title }
      elsif @sort == 'by_release_date'
        @movies = movies.sort_by &:release_date    
      else
        @movies = movies
      end
    end
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
