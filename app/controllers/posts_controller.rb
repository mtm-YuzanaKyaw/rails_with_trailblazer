class PostsController < ApplicationController
  include Trailblazer::Rails::Controller
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    # @post = Post.new
    run Post::Operations::Create::Present do |ctx|

      @form = ctx["contract.default"]
      render
    end
  end

  # GET /posts/1/edit
  def edit
    run Post::Operations::Update::Present do |ctx|
    @form   = ctx["contract.default"]
    @title  = "Editing #{ctx[:model].title}"

    render
  end
  end

  # POST /posts or /posts.json
  def create
    _ctx = run Post::Operations::Create do |ctx|
      return redirect_to posts_path, notice: "Post was successfully created."
    end

    @form = _ctx["contract.default"]
    render :new, notice: "Post was successfully created."
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    _ctx = run Post::Operations::Update do |ctx|
    flash[:notice] = "#{ctx[:model].title} has been saved"
      return redirect_to post_path(ctx[:model].id)
    end

    @form   = _ctx["contract.default"] # FIXME: redundant to #create!
    @title  = "Editing #{_ctx[:model].title}"

    render :edit
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :content, :user_id ])
    end
end
