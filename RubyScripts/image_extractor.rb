#!/usr/bin/env ruby

=begin

usage:

This script download all the images at the given URL into a given folder_name

./image_extractor.rb <url> <folder_name>

note: folder_name is optional

=end

class ImageExtractor
  require 'nokogiri'
  require 'open-uri'

  def initialize(url)
    @url=url
  end

  def get_base_url
    "#{URI(@url).scheme}://#{URI(@url).host}"
  end

  def get_nokogiri_object
    Nokogiri::HTML(open(@url))
  end

  def get_img_tags(nokogiri_object)
    nokogiri_object.css('img')
  end

  def get_imgurls_from_imgtags(imgtags)
    imgurls = []
    imgtags.each{ |img|
      imgurls << @url + "/#{img['src']}"
    }
    imgurls
  end

  def download_img_from_url_into_folder(url, folder)
    folder = Dir.pwd if folder.nil?
    open(url) {|f|
      File.open(folder +"/"+ File.basename(URI.parse(url).path),"wb") do |file|
        file.puts f.read
      end
    }
  end

  def download_all_images_into_folder(folder)
    Dir.mkdir(folder) if not folder.nil?
    no = get_nokogiri_object

    tags = get_img_tags(no)

    get_imgurls_from_imgtags(tags).each{ |url|
      download_img_from_url_into_folder(url,folder)
    }
  end

end

url =  ARGV[0]
folder = ARGV[1]

ImageExtractor.new(url).download_all_images_into_folder(folder)