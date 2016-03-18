class TestimonialsController < ApplicationController
  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]

  # GET /testimonials
  # GET /testimonials.json
  def index
    @testimonials = current_user.testimonials.all
  end

  # GET /posts
  # GET /posts.json
  def testimonils
    @testimonials = Testimonial.all
  end

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
    @testimonial = current_user.testimonials.where(id: params[:id]).first
  end

  # GET /testimonials/new
  def new
    @testimonials = current_user.testimonials.new
  end

  # GET /testimonials/1/edit
  def edit
  end

  # POST /testimonials
  # POST /testimonials.json
  def create
    @testimonial = current_user.testimonials.new(testimonial_params)
    @testimonial.user_name = current_user.name
    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully created.' }
        format.json { render :show, status: :created, location: @testimonial }
      else
        format.html { render :new }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testimonials/1
  # PATCH/PUT /testimonials/1.json
  def update
    @testimonial = current_user.bookmarks.find(params[:id])
    @bookmark.testimonial = params[:testimonial]
    @bookmark.title = params[:title]
    respond_to do |format|
      if @testimonial.update(testimonial_params)
        format.html { redirect_to @testimonial, notice: 'Testimonial was successfully updated.' }
        format.json { render :show, status: :ok, location: @testimonial }
      else
        format.html { render :edit }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonials/1
  # DELETE /testimonials/1.json
  def destroy
    @testimonial = current_user.bookmarks.find(params[:id])
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to testimonials_url, notice: 'Testimonial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(:testimonial, :title, :user_name, :user_id)
    end
end
