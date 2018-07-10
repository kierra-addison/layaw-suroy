class TagsController < ApplicationController
  before_action :require_user, only: [:new, :create, :edit, :update]

  def index
    @home_banner  = true
    
    unless params[:tag_search].blank?
      @home_banner  = false
      flash[:notice] = "Search Results for: #{params[:tag_search]}"
    end
    
    @tags = Tag.search(params[:tag_search]).order(created_at: :desc)
  end
  
  def show
    @tag = Tag.find(params[:id])
    @destinations = @tag.destinations
    session[:for_id] = @tag.id # Stores :for_id value for destinations#new & destination#create
    session[:for_tag_title] = @tag.title # Stores :for_tag_title value for destinations#new & destination#create
    session[:for_tag_description] = @tag.description # Stores :for_tag_description value for destinations#new & destination#create
  end
  
  def new
    @tag = Tag.new
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = "New destination tag successfully created"
      redirect_to @tag
    else
      render 'new'
    end
  end
  
  def edit
    @tag = Tag.find(params[:id])
  end
  
  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      flash[:success] = "Destination tag successfully updated"
      redirect_to @tag
    else
      render 'edit'
    end
  end
  
  private
    def tag_params
      params.require(:tag).permit(:title, :description, :image_header, image_uploads: [])
    end
end
