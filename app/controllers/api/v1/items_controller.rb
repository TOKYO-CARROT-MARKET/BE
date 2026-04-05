class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :require_authentication, only: %i[create update destroy my_items like]
  before_action :authorize_item_owner!, only: %i[update destroy]

  def index
    items = Item.includes(:user).order(created_at: :desc)

    items = items.where("title ILIKE :q OR description ILIKE :q", q: "%#{params[:q]}%") if params[:q].present?
    items = items.where(region: params[:region]) if params[:region].present?
    items = items.where(category: params[:category]) if params[:category].present?
    items = items.where(status: params[:status]) if params[:status].present?
    items = items.where("price >= ?", params[:price_min].to_i) if params[:price_min].present?
    items = items.where("price <= ?", params[:price_max].to_i) if params[:price_max].present?
    if params[:available_date].present?
      items = items.where("available_from <= :d AND departure_date >= :d", d: params[:available_date])
    end

    limit  = [ params.fetch(:limit, 100).to_i, 100 ].min
    offset = params.fetch(:offset, 0).to_i

    items = items.limit(limit).offset(offset)

    render json: items.map { |item| item_response(item) }
  end

  def show
    @item.increment!(:views_count)
    liked = current_user ? @item.likes.exists?(user: current_user) : false
    render json: item_response(@item, liked_by_current_user: liked)
  end

  def like
    item = Item.find(params[:id])
    existing = item.likes.find_by(user: current_user)

    if existing
      existing.destroy
      render json: { liked: false, likes_count: item.reload.likes_count }
    else
      item.likes.create!(user: current_user)
      render json: { liked: true, likes_count: item.reload.likes_count }
    end
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

  def item_response(item, liked_by_current_user: false)
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
      views_count: item.views_count,
      likes_count: item.likes_count,
      liked_by_current_user: liked_by_current_user,
      created_at: item.created_at,
      updated_at: item.updated_at,
      user: {
        id: item.user.id,
        email: item.user.email
      }
    }
  end
end
