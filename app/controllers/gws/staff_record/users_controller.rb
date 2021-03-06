class Gws::StaffRecord::UsersController < ApplicationController
  include Gws::BaseFilter
  include Gws::CrudFilter

  model Gws::StaffRecord::User

  navi_view "gws/staff_record/settings/navi"

  before_action :set_year

  private

  def set_crumbs
    set_year
    @crumbs << [t("mongoid.models.gws/staff_record/group_setting"), gws_staff_record_setting_path]
    @crumbs << ["#{@cur_year.name} " + t("mongoid.models.gws/staff_record/user"), gws_staff_record_users_path]
  end

  def set_year
    @cur_year ||= Gws::StaffRecord::Year.site(@cur_site).find(params[:year])
  end

  def fix_params
    { cur_user: @cur_user, cur_site: @cur_site, year_id: @cur_year.id }
  end

  public

  def index
    @items = @cur_year.yearly_users.site(@cur_site).
      allow(:read, @cur_user, site: @cur_site).
      search(params[:s]).
      page(params[:page]).per(50)
  end

  def download
    items = @cur_year.yearly_users.site(@cur_site).
      allow(:read, @cur_user, site: @cur_site)

    @item = @model.new(fix_params)
    @item.site_id = @cur_site.id
    @item.export_csv(items)

    send_data @item.export_csv(items), filename: "staff_record_#{@cur_year.code}_users_#{Time.zone.now.to_i}.csv"
  end

  def import
    return if request.get?
    @item = @model.new(get_params)
    @item.site_id = @cur_site.id

    result = @item.import_csv
    flash.now[:notice] = t("ss.notice.saved") if result
    render_create result, location: { action: :index }, render: { file: :import }
  end
end
