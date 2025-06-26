module Post::Contract
  class Create < Reform::Form 
    include Dry
    property :title
    property :content
    property :user_id

    validation do
      to_param do
        required(:title).filled
        required(:body).maybe(min_size?: 9)
      end
    end
  end
end