module ApplicationHelper
  def asset_exists?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include?(path)
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  rescue
    false
  end

  def cart_items_count
    return 0 unless user_signed_in?
    current_user.cart&.total_items || 0
  end
end
