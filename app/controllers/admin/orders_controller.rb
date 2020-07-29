class Admin::OrdersController < Admin::AdminController

	def edit_introducer
		@order = Order.find params[:id]
    	respond_to do |format|
      		format.js
    	end
	end

	def update_introducer
		@order = Order.find params[:id]
		@order.introducer_id = params[:order][:introducer_id]
		@order.save(validate: false)
    	respond_to do |format|
      		format.js
    	end
	end
end
