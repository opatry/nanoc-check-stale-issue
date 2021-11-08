require 'image_size'

# defines the way a picture is inserted according to current item representation
#  * if excerpt, the picture is resized to the excerpt size (see nanoc.yaml)
#  * if default, the picture is resized to default size (see nanoc.yaml)
#  * if raw, the picture is kept as its source version
# When excerpt representation is used, a link to the original item wraps the picture
# If the align parameter is defined and valid (right, left, center) it is applied to the picture
def picture(identifier, params = {})
  # finds the Nanoc item matching the given path
  image = @items[identifier]

  if image.nil?
    raise "unable to find image: #{identifier}"
  end

  puts "image=#{image.raw_filename}"
  image.reps.each do |rep|
    puts "  - #{rep.name}"
  end

  # TODO align using given params if any

  # choose the image representation matching the current item one
  if @item_rep.name == :feed
    image_repr = @item.reps[:default]
  else
    image_repr = @item_rep
  end

  real_image = ImageSize.new(IO.read(image.raw_filename))
  resized_width = params[:width] || @config[:picture_width][image_repr.name]
  resized_height = real_image.height * resized_width / real_image.width

  image_path = image.path rep: "#{image_repr.name}_original".to_sym
  puts "image_path = #{image_path}"
  image_path_html = image_path #escape_uri(image_path).gsub('%2F', '/')
  image_basename = File.basename(image.raw_filename, '.*')
  image_html_id = "picture_#{image_basename}"
  # setting width & height improves repaint & reflows during rendering (http://browserdiet.com/en/#scale)
  # inline max-width/height CSS styles to allow combination width HTML width/height attributes
  image_tag = "<img src=\"#{image_path_html}\" loading=\"lazy\" id=\"#{image_html_id}\" width=\"#{resized_width}\" height=\"#{resized_height}\" alt=\"#{image_basename}\"/>"

  webp_image_path = image.path rep: "#{image_repr.name}_webp".to_sym
  picture_tag = <<~PICTURE_TAG
                  <picture>
                    <source type="image/webp" srcset="#{webp_image_path}">
                    #{image_tag}
                  </picture>
                PICTURE_TAG

  out = if @item_rep.name == :excerpt
          item_path_html = @item.path # escape_uri(@item.path).gsub('%2F', '/')
          # do not link directly to image anchor, it makes the result a bit weird (to be considered with #175)
          out = "<a href=\"#{item_path_html}\" title=\"voir la suite…\">#{picture_tag}</a>"
        else
          picture_tag
        end
  "<p markdown=\"0\" class=\"picture-wrapper\">#{out}</p>"
end
