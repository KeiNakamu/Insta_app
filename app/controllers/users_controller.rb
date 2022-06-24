class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(current_user.id)
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    # respond_to do |format|
      if @user.save
         redirect_to user_path(@user.id)
        # format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        # format.json { render :show, status: :created, location: @user }
      else
        render :new
        # format.html { render :new, status: :unprocessable_entity }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "ユーザーの内容を更新しました"
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit
    end
  end

  def favorite
    @favorite_all = current_user.favorite_pictures
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :image, :image_cache, :password, :password_confirmation)
    end
end
