# require "test_helper"

# class ProductTest < ActiveSupport::TestCase
#   include ActionMailer::TestHelper

#   test "sends email notifications when back in stock" do
#     product = products(:tshirt)

#     # 製品を在庫切れにする
#     product.update(inventory_count: 0)

#     assert_emails 2 do
#       product.update(inventory_count: 99)
#     end
#   end
# end
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper       # deliver_later を同期で実行
  include ActionMailer::TestHelper    # assert_emails を使えるようにする

  test "sends email notifications when back in stock" do
    product = products(:one)
    subscriber = subscribers(:one)

    assert_emails 1 do
      perform_enqueued_jobs do
        product.notify_subscribers
      end
    end
  end
end