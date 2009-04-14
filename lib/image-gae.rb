require 'java'


    
module GAE
  module IS 
    import com.google.appengine.api.images.Image
    import com.google.appengine.api.images.ImagesService
    import com.google.appengine.api.images.ImagesServiceFactory
    import com.google.appengine.api.images.Transform
  
    Service = ImagesServiceFactory.images_service
  end
    
  class Image
    def self.open filename
      File.open(filename) do |file|
        return new(file.read)
      end
    end      
    
    def height
      @image.getHeight
    end
    def width
      @image.getWidth
    end 
     
    def initialize data
      @image =  IS::ImagesServiceFactory.make_image(data.to_java_bytes)      
    end    
    def apply_transform transform
      Image.new(data).deep_transform(transform)
    end
    def deep_transform transform
      IS::Service.apply_transform(transform,@image)
      self
    end    
    def resize width,height
      apply_transform IS::ImagesServiceFactory.make_resize(width, height)
    end
    def resize! width,height
      @image = resize(width,height)
    end    
    def rotate degree
      apply_transform IS::ImagesServiceFactory.make_rotate(degree)
    end
    def rotate! degree
      @image = rotate(degree)
    end        
    def flip direction = :horizontal      
      return apply_transform IS::ImagesServiceFactory.make_horizontal_flip if direction.to_sym == :horizontal
      return apply_transform IS::ImagesServiceFactory.make_vertical_flip if direction.to_sym == :vertical
      raise ArgumentError,'Direction must be :horizontal or :vertical'
    end
    def flip! direction
      @image = flip(direction)
    end   
    def crop leftX,topY,rightX,bottomY
      apply_transform IS::ImagesServiceFactory.make_crop(leftX,topY,rightX,bottomY)   
    end
    def crop! leftX,topY,rightX,bottomY
      @image = crop(leftX,topY,rightX,bottomY)
    end      
    def i_feel_lucky 
      apply_transform IS::ImagesServiceFactory.make_im_feeling_lucky  
    end
    def i_feel_lucky! 
      @image = i_feel_lucky
    end     
    def data
      String.from_java_bytes @image.image_data     
    end    
    alias :to_s :data
  end
end

