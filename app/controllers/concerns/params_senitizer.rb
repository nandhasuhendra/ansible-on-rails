module ParamsSenitizer
  def senitizer(params)
    params.each do |value| 
      if value.is_a? Array
        next
      else
        value.squish
      end
    end
  end
end
