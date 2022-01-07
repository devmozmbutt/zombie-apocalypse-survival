module ApplicationHelper
  def show_image_if_present(resource)
    if resource.photo.record.photo.present?
      img = resource.photo
      image_tag img, width: '200'
    end
  end
end
