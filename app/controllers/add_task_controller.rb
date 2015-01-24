class AddTaskController < UIViewController
  def viewDidLoad
    super

    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    view.contentMode = UIViewContentModeRedraw

    view.backgroundColor = UIColor.whiteColor
    self.title = "Add Task"
    view.addSubview generate_text_field
    view.addSubview generate_description_field
    view.addSubview generate_button

    @todolist = ToDoList.load_from_defaults || ToDoList.new
  end

  def viewDidUnload
    @data = nil
  end

  def touchesBegan(touches, withEvent:event)
    view.endEditing(true)
  end

  # called when 'return' key pressed. return NO to ignore.
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
  end

  def addTask(sender)
    @todolist.tasks << Task.new(name: @name_field.text, description: @desc_field.text)
    @todolist.save!
    view.endEditing(true)
    @name_field.text = ""
    @desc_field.text = ""
    navigationController.popViewControllerAnimated(true)
  end

  private

  def generate_text_field
    @name_field ||= UITextField.alloc.initWithFrame(CGRectMake(0, 0, 300, 50)).tap do |field|
      field.placeholder = 'Enter task name here'
      field.borderStyle = UITextBorderStyleLine
      field.center = CGPointMake(
        view.frame.size.width / 2,
        view.frame.size.height / 2 - 30,
      )
      field.delegate = self
    end
  end

  def generate_description_field
    @desc_field ||= UITextField.alloc.initWithFrame(CGRectMake(0, 0, 300, 50)).tap do |field|
      field.placeholder = 'Enter task description here'
      field.borderStyle = UITextBorderStyleLine
      field.center = CGPointMake(
        view.frame.size.width / 2,
        view.frame.size.height / 2 + 30,
      )
      field.delegate = self
    end
  end

  def generate_button
    UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |btn|
      btn.frame = CGRectMake(0, view.frame.size.height / 2 + 100, 300, 50)
      btn.setTitle('Add Task', forState: UIControlStateNormal)
      btn.addTarget(self, action: "addTask:", forControlEvents: UIControlEventTouchUpInside)
    end
  end
end
