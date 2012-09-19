class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @@sort_choices = ['title', 'release_date']
    
    all_ratings = Movie.all(:select => 'DISTINCT rating').collect{|x| x.rating}
    #handle session checks
    if !session[:checked]
      session[:ratings] = Hash[all_ratings.collect{|x| [x, '1']}]
      session[:checked] = true and session[:ratings]
    end
    
    # handle sort checks
    if @@sort_choices.include?(params[:sort])
      session[:sort] = params[:sort]
    end  
    
    @sort = session[:sort]
    
    #handle ratings checks
    if params[:commit] or params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    @ratings = session[:ratings]
    
    
    if @sort != params[:sort_on] && @ratings != params[:ratings]
      redirect_to movies_path(:sort => @sort, :ratings =>@ratings)
    end
    
    @ratings or @ratings = {}
    
    @all_ratings = Movie.all(:select => 'DISTINCT rating').collect{|x| x.rating}
    
    @movies = Movie.all(:order => @sort, :conditions => {:rating => @ratings.keys})
    
    #@sort = params[:sort]
      
    #@ratings = {}
    #if params[:ratings]
    #  @ratings[:ratings] = params[:ratings]
    #  @filter = params[:ratings].keys
    #  filters = {:rating => @filter}
    #else
    #  @filter = {}
    #end
    

    
    
    #if (filters == nil) && (@sort == nil) && (not session[:params].empty?)
    #  redirect_to movies_path(session[:params])
    #else
    #  redirect_to movies_path()
    #end
  
    
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
    
    
    #@all_ratings = Movie.all(:select => 'DISTINCT rating').collect{|x| x.rating}
    #@movies = Movie.where(filters).order(@sort)
    
    #session[:params] = @ratings.merge({:sort => @sort})
   
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
