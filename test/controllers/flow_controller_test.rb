require 'test_helper'

class FlowControllerTest < ActionDispatch::IntegrationTest
  test 'get index success' do
    get '/'
    assert_response :ok
  end
end
