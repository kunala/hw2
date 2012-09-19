class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @sort = params[:sort]
      
    @ratings = {}
    if params[:ratings]
      @ratings[:ratings] = params[:ratings]
      @filter = params[:ratings].keys
      filters = {:rating => @filter}
    else
      @filter = {}
    end
    
    if (filters == nil) && (@sort == nil) && session[:params]
      redirect_to movies_path(session[:params])
    end
  
    
    #if @sort == "title"
    #  @movies = Movie.order('title ASC')
    #elsif @sort == 'release_date'
    #  @movies = Movie.order('release_date ASC')
    #else
    #  @movies = Movie.all
    #end
    
    #puts "open"
    #puts session[:ratings]
    #puts "closed"
    
    
    @all_ratings = Movie.all(:select => 'DISTINCT rating').collect{|x| x.rating}
    @movies = Movie.where(filters).order(@sort)
    
    session[:params] = @ratings.merge({:sort => @sort})
   
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
