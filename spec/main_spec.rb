describe "Application 'YATDL'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has two windows" do
    @app.windows.size.should == 2
  end

  it "has a task manager that I can add tasks to" do
    todolist = ToDoList.new
    todolist.tasks.push Task.new(:name => "Write app", description: "in Rubymotion")

    todolist.tasks.size.should == 1
  end

  it "creates and saves tasks" do
    task = Task.new(:name => "Derp", :description => "Desc", :id => "derp")
    task.save!

    reloaded_task = Task.load_from_defaults("derp")
    reloaded_task.name.should == "Derp"
  end

  it "creates and saves todolists" do
    todolist = ToDoList.new
    todolist.tasks << Task.new(:name => "Derp", :description => "Desc", :id => "tdl")
    todolist.save!

    reloaded_todolist = ToDoList.load_from_defaults
    reloaded_todolist.tasks.first.name.should == "Derp"
  end
end
