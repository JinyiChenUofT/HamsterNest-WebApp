class BorrowRequestsController < ApplicationController
  def index
    @borrow_requests = BorrowRequest.all
  end

  def show
    @borrow_request = BorrowRequest.find(params[:id])
  end

  def new
    @borrow_request = BorrowRequest.new
    @item_id = params[:item_id]
    @item = Item.find(@item_id)
    @item_name = @item.item_name
  end

  def edit
    @borrow_request = BorrowRequest.find(params[:id])
  end

  def create
    @borrow_request = BorrowRequest.new(request_params)
    @item_id = @borrow_request.item_id
    @item = Item.find(@item_id)

    if @borrow_request.save
      flash[:notice] = "Borrow request created."
      redirect_to @borrow_request
    else
      flash[:alert] = @borrow_request.errors.full_messages
      render "new"
    end
  end

  def update
    @borrow_request = BorrowRequest.find(params[:id])
    if @borrow_request.update(request_params)
      flash[:notice] = "Borrow request updated."
      redirect_to @borrow_request
    else
      flash[:alert] = @borrow_request.errors.full_messages
      render "edit"
    end
  end

  def destroy
    @borrow_request = BorrowRequest.find(params[:id])
    @borrow_request.destroy

    redirect_to borrow_requests_path
  end

  private

  def request_params
    params.require(:borrow_request).permit(:item_id, :approval, :borrow_date, :return_date, :request_message)
  end
end
