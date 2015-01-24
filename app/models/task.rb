# A Task - has a name and description
class Task
  PROPERTIES = %w[name description id]
  PROPERTIES.each { |p| attr_accessor p }
  include Saveable

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
    self.id ||= (0..16).to_a.map { |a| rand(16).to_s(16) }.join
  end

  def save!
    DEFAULTS["task_" + id] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  def self.load_from_defaults(id)
    if DEFAULTS.dictionaryRepresentation.keys.include?("task_#{id}")
      NSKeyedUnarchiver.unarchiveObjectWithData(DEFAULTS["task_#{id}"])
    else
      fail "Task cannot be found"
    end
  end

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`
  def initWithCoder(decoder)
    init
    PROPERTIES.each do |k|
      send(k + "=", decoder.decodeObjectForKey(k))
    end
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    PROPERTIES.each do |k|
      encoder.encodeObject(send(k), forKey: k)
    end
  end
end
