class HomeController < ActionController::Base
  def index
    @link = Link.new
  end

  def create
    original_url = link_params[:original_url]
    @link = Link.new(original_url: original_url)

    if @link.save
      render :index
    else
      flash.now[:alert] = "Error creating link: #{@link.errors.full_messages.join(', ')}"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end
end
