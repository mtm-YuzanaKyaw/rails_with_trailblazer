module Post::Contract
  class Create < Reform::Form 
    property :title
    property :content
    property :user_id

    validates :title, presence: true 
    validates :content, presence: true
  end
end