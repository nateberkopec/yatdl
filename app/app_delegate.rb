class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible

    true
  end

  private

  def nav_controller
    UINavigationController.alloc.initWithRootViewController(
      ToDoListController.new
    )
  end

end
