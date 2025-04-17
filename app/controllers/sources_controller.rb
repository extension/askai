# app/controllers/sources_controller.rb
class SourcesController < ApplicationController
  before_action :require_admin
  before_action :set_source, only: [:edit, :update, :destroy]

  def index
    @sources = Source.all.order(:name)
  end

  def new
    @source = Source.new
  end

  def create
    @source = Source.new(source_params)
    if @source.save
      redirect_to sources_path, notice: "Source created!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @source.update(source_params)
      redirect_to sources_path, notice: "Source updated!"
    else
      render :edit
    end
  end

  def destroy
    @source.destroy
    redirect_to sources_path, notice: "Source deleted."
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:name, :provider, :is_human)
  end

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end