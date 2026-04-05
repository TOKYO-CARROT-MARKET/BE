class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :require_authentication, only: %i[create update destroy my_items]
  before_action :authorize_item_owner!, only: %i[update destroy]

  def index
    items = Item.includes(:user).order(created_at: :desc)
    render json: items.map { |item| item_response(item) }
  end

  def show
    render json: item_response(@item)
  end

  def my_items
    items = current_user.items.order(created_at: :desc)
    render json: items.map { |item| item_response(item) }
  end

  def create
    item = current_user.items.new(item_params)

    if item.save
      render json: item_response(item), status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: item_response(@item)
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.includes(:user).find(params[:id])
  end

  def authorize_item_owner!
    return if @item.user_id == current_user.id

    render json: { error: "Forbidden" }, status: :forbidden
  end

  def item_params
    params.require(:item).permit(
      :title,
      :description,
      :price,
      :category,
      :region,
      :pickup_type,
      :available_from,
      :departure_date,
      :status,
      images: []
    )
  end

  def item_response(item)
    {
      id: item.id,
      title: item.title,
      description: item.description,
      price: item.price,
      category: item.category,
      region: item.region,
      images: item.images || [],
      pickup_type: item.pickup_type,
      available_from: item.available_from,
      departure_date: item.departure_date,
      status: item.status,
      created_at: item.created_at,
      updated_at: item.updated_at,
      user: {
        id: item.user.id,
        email: item.user.email
      }
    }
  end
end
