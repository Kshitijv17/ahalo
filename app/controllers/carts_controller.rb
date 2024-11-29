class CartsController < ApplicationController
    # before_action :authenticate_user!
    before_action :set_cart
    before_action :set_cart_item, only: [:remove_item, :update_quantity]
  
    def show
    end
  
    def add_item
      product = Product.find(params[:product_id])
      cart_item = @cart.cart_items.find_or_initialize_by(product: product)
      cart_item.quantity = cart_item.quantity.to_i + 1
  
      if cart_item.save
        redirect_back fallback_location: root_path, notice: 'Item added to cart.'
      else
        redirect_back fallback_location: root_path, alert: 'Could not add item to cart.'
      end
    end
  
    def remove_item
      if @cart_item
        @cart_item.destroy
        redirect_back fallback_location: cart_path, notice: 'Item removed from cart.'
      else
        redirect_back fallback_location: cart_path, alert: 'Item not found in cart.'
      end
    end
  
    def update_quantity
      if @cart_item && @cart_item.update(quantity: params[:quantity])
        redirect_back fallback_location: cart_path, notice: 'Quantity updated.'
      else
        redirect_back fallback_location: cart_path, alert: 'Could not update quantity.'
      end
    end
  
    private
  
    def set_cart
      @cart = current_user.cart || current_user.create_cart
    end
  
    def set_cart_item
      @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    end
  end
  