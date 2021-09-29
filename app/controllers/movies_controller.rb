class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      @all_ratings = Movie.all_ratings

      @sort_by = params[:sort] || session[:sort]
      @ratings_to_show = params[:ratings] || session[:ratings]

      if !@ratings_to_show
        @ratings_to_show = Hash.new
        @all_ratings.each {|r| @ratings_to_show[r] = 1}
      end

      session[:sort], session[:ratings] = @sort_by, @ratings_to_show

      if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
        flash.keep
        redirect_to movies_path :sort => @sort_by, :ratings => @ratings_to_show
      end

      @movies.where!(rating: @ratings_to_show.keys).order!(@sort_by)

      case @sort_by
          when 'title'
            @title_header_class = 'hilite'
          when 'release_date'
            @release_date_header_class = 'hilite'
          end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end