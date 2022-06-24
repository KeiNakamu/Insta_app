class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /pictures or /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1 or /pictures/1.json
  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  # GET /pictures/new
  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures or /pictures.json
  def create
    @picture = current_user.pictures.build(picture_params)
    if params[:back]
        render :new
    else
      if @picture.save
        PictureMailer.picture_mail(@picture).deliver
        redirect_to pictures_path, notice: "投稿しました！"
      else
        render :new
      end
    end
  end

  # PATCH/PUT /pictures/1 or /pictures/1.json
  def update
    @picture = Picture.find(params[:id])
    if @picture.update(picture_params)
      redirect_to  pictures_path, notice: "投稿を編集しました！"
    else
      render :edit
    end
  end

  # DELETE /pictures/1 or /pictures/1.json
  def destroy
    @picture.destroy
    redirect_to pictures_url, notice: "削除しました"
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_picture
    @picture = Picture.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def picture_params
    params.require(:picture).permit(:title, :image, :image_cache, :content)
  end

  def correct_user
    unless Picture.find(params[:id]).user.id.to_i == current_user.id
        redirect_to pictures_path(current_user)
        flash[:notice] = "権限がありません"
    end
  end
end
