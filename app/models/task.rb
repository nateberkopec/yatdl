class Task
  attr_accessor :name
  attr_accessor :description
  attr_accessor :id

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value)
    }
    self.id ||= (0..16).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def self.defaults
    NSUserDefaults.standardUserDefaults
  end

  def save!
    self.class.defaults["task_" + id] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  def self.load_from_defaults(id)
    if defaults.dictionaryRepresentation.keys.include?("task_#{id}")
      NSKeyedUnarchiver.unarchiveObjectWithData(defaults["task_#{id}"])
    else
      raise "Task cannot be found"
    end
  end

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`
  def initWithCoder(decoder)
    init
    %w[name description id].each do |k|
      send(k + "=", decoder.decodeObjectForKey(k))
    end
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    %w[name description id].each do |k|
      encoder.encodeObject(send(k), forKey: k)
    end
  end
end
