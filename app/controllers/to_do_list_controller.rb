class ToDoListController < UIViewController
  def viewDidLoad
    super

    self.title = "To-Do List"
    @table = UITableView.alloc.initWithFrame(view.bounds).tap do |table|
      table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      table.contentMode = UIViewContentModeRedraw
    end
    view.addSubview @table
    @table.dataSource = self
    @table.delegate = self

    @todolist = ToDoList.load_from_defaults || ToDoList.new
    @data = @todolist.tasks

    navigationItem.rightBarButtonItem = right_button
  end

  def viewDidUnload
    @data = nil
  end

  def viewDidAppear(animated)
    @todolist = ToDoList.load_from_defaults || ToDoList.new
    @data = @todolist.tasks
    @table.reloadData
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
           default_table_view_cell
    cell.textLabel.text = @data[indexPath.row].name
    cell.detailTextLabel.text = @data[indexPath.row].description
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.length
  end

  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   tableView.deselectRowAtIndexPath(indexPath, animated: true)

  #   UIAlertView.alloc.init.tap do |alert|
  #     alert.message = "#{@data[indexPath.row]} tapped!"
  #     alert.addButtonWithTitle 'SWEET!'
  #     alert.show
  #   end
  # end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      @data.delete_at(indexPath.row)
      @todolist.save!
      @table.reloadData
    end
  end

  def add_task
    navigationController.pushViewController(AddTaskController.new, animated: true)
  end

  private

  def default_table_view_cell
    UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleSubtitle,
      reuseIdentifier:@reuseIdentifier
    )
  end

  def right_button
    UIBarButtonItem.alloc.initWithTitle(
      'New Task',
      style: UIBarButtonItemStyleBordered,
      target:self,
      action:'add_task'
    )
  end
end
