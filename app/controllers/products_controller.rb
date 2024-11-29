class ProductsController < ApplicationController
     
     def index
      Rails.logger.debug "Params: #{params.inspect}"

      if params[:cat].present?
        @product = Product.where(cat: params[:cat].to_sym)
      else
        # @product = Product.all
        @product = Product.paginate(page: params[:page], per_page: 10)
      end
      # render json: @product
      Prawn::Document.generate("hello.pdf") do
        text "Hello World!"
      end
     end

      def show 
         @product = Product.find(params[:id])
      end

        def new
          @product = Product.new
        end
      
        def create
          @product = Product.new(product_params)
      
          if @product.save
            redirect_to root_path, notice: "Product was successfully added."
          else
            render :new
          end
        end
      
        private
      
        def product_params
          params.require(:product).permit(:name,:stat, :cat,:avatar)
        end
    
end
