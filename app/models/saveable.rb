module Saveable
  DEFAULTS = NSUserDefaults.standardUserDefaults

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`
  def initWithCoder(decoder)
    init
    self.class::PROPERTIES.each do |k|
      send(k + "=", decoder.decodeObjectForKey(k))
    end
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    self.class::PROPERTIES.each do |k|
      encoder.encodeObject(send(k), forKey: k)
    end
  end

  def primary_key
    "#{self.class}_#{id}"
  end
end
