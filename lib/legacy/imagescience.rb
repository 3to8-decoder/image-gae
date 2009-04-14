module GAE
 module Legacy
    class ImageScience
      def self.with_image path
        yield ImageScience.new(Image.open(path))        
      end
      def self.with_image_data data
        yield ImageScience.new(Image.new(data))        
      end
      def initialize image
        @image = image
      end
      def save path
        File.open(path,"w") do |f|
          f.write @image.to_s
        end
      end
      def to_s 
        @image.to_s
      end
      
      def cropped_thumbnail(size) # :yields: image
        w, h = width, height
        l, t, r, b, half = 0, 0, w, h, (w - h).abs / 2
        
        l, r = half, half + h if w > h
        t, b = half, half + w if h > w
      
        with_crop(l, t, r, b) do |img|
          img.thumbnail(size) do |thumb|
            yield thumb
          end
        end
      end
      def resize(w, h) 
        yield @image.resize(w,h)
      end
      def thumbnail(size) # :yields: image
        w, h = width, height
        scale = size.to_f / (w > h ? w : h)    
        self.resize((w * scale).to_i, (h * scale).to_i) do |image|
          yield image
        end
      end
      def with_crop(left, top, right, bottom) 
        yield ImageScience.new @image.crop(left.to_f/width.to_f, top.to_f/height.to_f , right.to_f/width.to_f, bottom.to_f/height.to_f )
      end      
      def height 
        @image.height
      end
      def width 
        @image.width
      end
    end      
  end  
end