module Post::Operations
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Post, :new)
      step Contract::Build(constant: Post::Contract::Create)
    end

    step Subprocess(Present)
    step Contract::Validate(key: :post)
    step Contract::Persist()
    step :notify!

    def notify!(ctx, model:, **)
      ctx["result.notify"] = Rails.logger.info("New blog post #{model.title}.")
    end

    def assign_user(ctx, model:, **)
      model.user = current_user
    end
  end
end
