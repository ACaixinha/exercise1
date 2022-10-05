require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  def set_session
    # @user = users(:two)
    post sessions_url, params: { session: { password: 'some_password', username: @user.username } }
  end

  test 'should get index' do
    get products_url, as: :json
    assert_response :success
  end

  test 'should create product' do
    @user = users(:two)
    set_session
    assert_difference('Product.count') do
      post products_url,
           params: { product: {
             amount_available: @product.amount_available,
             cost: @product.cost, product_name: @product.product_name,
             seller_id: @product.seller_id
           } }, as: :json
    end

    assert_response :created
  end

  test 'should show product' do
    get product_url(@product), as: :json
    assert_response :success
  end

  test 'should update product' do
    @user = users(:two)
    set_session
    patch product_url(@product), params: { product: { cost: @product.cost, product_name: @product.product_name } },
                                 as: :json
    assert_response :success
  end

  test 'should destroy product' do
    @user = users(:two)
    set_session
    assert_difference('Product.count', -1) do
      delete product_url(@product), as: :json
    end

    assert_response :no_content
  end

  test 'should not destroy product of another seller' do
    @user = users(:two)
    another_user = users(:three)
    @product.update_column :seller_id, another_user.id
    set_session
    delete product_url(@product), as: :json
    assert_response :forbidden
  end

  test 'products#buy' do
    @user = users(:one)
    product = products(:one)
    set_session
    current_deposit = @user.deposit
    ammount = 2

    post "/products/#{@user.id}/buy", params: { ammount: }, as: :json
    assert_response :success
  end
end
