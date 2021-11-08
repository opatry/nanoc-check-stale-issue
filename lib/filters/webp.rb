# frozen_string_literal: true

class Webp < Nanoc::Filter
  identifier :webp
  type       :binary

  # '-resize',
  # "#{params[:width]} 0",
  def run(filename, params = {})
    system(
      'cwebp',
      '-quiet',
      '-q',
      '80', # @config[:picture_quality].dup.chop!,
      filename,
      '-o',
      output_filename
    )
  end
end
