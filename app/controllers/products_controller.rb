class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :search
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy
      redirect_to root_path
    else
      render :search
    end
  end

  def search
    @products = Product.all
    if params[:keyword]
      @items = RakutenWebService::Ichiba::Item.search(keyword: params[:keyword],sort: '+itemPrice',minPrice: params[:minPrice],NGKeyword: '中古',imageFlag: '1',itemId: 'alude:10179937')
    end
  end


private

  def product_params
    params.require(:product).permit(:name, :price, :code)
  end

end
