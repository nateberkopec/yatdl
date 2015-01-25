# Container for a list of Tasks
class ToDoList
  attr_accessor :tasks, :id

  PROPERTIES = %w[task_ids]

  include Saveable

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

  def task_ids
    tasks.map(&:id)
  end

  def task_ids=(ids)
    self.tasks = ids.map { |id| Task.load_from_defaults(id) }
  end
end
