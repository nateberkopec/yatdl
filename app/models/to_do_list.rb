# Container for a list of Tasks
class ToDoList
  attr_accessor :tasks

  DEFAULTS = NSUserDefaults.standardUserDefaults

  def initialize(*)
    self.tasks = []
  end

  def save!
    tasks.map(&:save!)
    DEFAULTS["to_do_list"] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  def self.load_from_defaults
    NSKeyedUnarchiver.unarchiveObjectWithData(DEFAULTS["to_do_list"])
  end

  def initWithCoder(decoder)
    ids = decoder.decodeObjectForKey("task_ids")
    self.tasks = ids.map { |id| Task.load_from_defaults(id) }
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    encoder.encodeObject(tasks.map(&:id), forKey: "task_ids")
  end
end
