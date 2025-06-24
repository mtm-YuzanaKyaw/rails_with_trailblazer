module Post::Operations
  class Create < Trailblazer::Operation
      step :model
      # step Policy::Pundit(-> (ctx,**) { true })
      step Contract::Build(constant: Post::Contract::Create)
      step Contract::Validate()
      step ->(ctx, model:, **) {model.user = ctx[:current_user]}
      step Contract::Persist()  
    end
end

# require "trailblazer/operation"
# require "trailblazer/macro/model"
# require "trailblazer/macro/contract"

# module Post::Operations::Create
#   class Present < Trailblazer::Operation::Railway
#     extend Trailblazer::Operation::DSL
#     include Trailblazer::Macro::Model
#     include Trailblazer::Macro::Contract

#     step Model(Post, :new)
#     step Contract::Build(constant: Post::Contract::Create)
#   end
# end
