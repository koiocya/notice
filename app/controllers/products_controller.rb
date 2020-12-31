class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect to root_path
    else
      render :new
    end
  end

  def search
  end


  private
  
    def product_params
      params.require(:product).permit(:name, :price, :code)
    end

end
