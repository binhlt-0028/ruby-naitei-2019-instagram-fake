class ReportsController < ApplicationController
  def create
    @report = current_user.reports.build(post_id: params[:post_id])
    status = @report.save ? 200 : 404
    respond_to do |format|
      format.json do
        render json: {status: status}
      end
    end
  end
end
