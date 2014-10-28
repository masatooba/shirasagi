class Contact::SearchGroupsController < ApplicationController
  include Cms::BaseFilter
  include SS::CrudFilter
  include SS::AjaxFilter

  model Cms::Group

  public
    def index
    end

    def search
      @items = @model.site(@cur_site).
        search(params[:q]).
        order_by(_id: -1)

      render layout: !request.xhr?
    end
end