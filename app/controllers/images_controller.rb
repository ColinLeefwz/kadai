# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :auth_current_user

  # GET /images
  def index
    @images = Image.all
  end

  # GET /images/new
  def new; end

  # POST /images
  def create; end

  # GET /image/:id
  def show; end
end
