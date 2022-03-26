# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :auth_current_user

  # GET /images
  def index
    create_result = TwitterAppAuthUrlCreator.call
    @author_url = create_result.payload[:url] if create_result.success?
    @images = Image.all
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # POST /images
  def create
    @image = Image.new(image_params)
    return redirect_to images_path, flash: { notice: '作成が成功しました。' } if @image.save

    flash.now[:alert] = @image.errors.full_messages
    render :new
  end

  private

  def image_params
    params.require(:image).permit(:title, :avatar)
  end
end
