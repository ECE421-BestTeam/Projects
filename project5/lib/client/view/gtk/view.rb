require 'gtk2'
require_relative './helper'
require_relative './board'
require_relative '../../controller/menu'

# should not contain any logic as it is the view
class GtkView
  
  # creates the board and sets the listeners
  def initialize
    # the menu options
    @controller = MenuController.new
    @gameSettings = GameSettingsModel.new
    @gameSettings.players = 1;
    setupWindow
  end
  
  def setupWindow
    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    GtkHelper.applyEventHandler(@window, "destroy") do
      Gtk.main_quit
    end
    @window.title = "Connect4.2"
    
    panels = Gtk::VBox.new
    
    gameButton = Gtk::Button.new "Game"
    accountButton = Gtk::Button.new "Account"
    serverButton = Gtk::Button.new "Server"
    statsButton = Gtk::Button.new "Stats"
    GtkHelper.applyEventHandler(gameButton, :clicked) {switchContext :game}
    GtkHelper.applyEventHandler(accountButton, :clicked) {switchContext :account}
    GtkHelper.applyEventHandler(serverButton, :clicked) {switchContext :server}
    GtkHelper.applyEventHandler(statsButton, :clicked) {switchContext :stats}
    menu = GtkHelper.createBox('H',
      [ { :widget => gameButton },
        { :widget => accountButton },
        { :widget => serverButton },
        { :widget => statsButton } ] )
    panels.pack_start menu
    
    @mainPanel = Gtk::EventBox.new
    panels.add @mainPanel
    
    @window.add panels
    
    initNewGameWidget
    initGameBoardWidget
    initLoginWidget
    initLogoutWidget
    initServerWidget
    initStatsWidget
    
    switchContext :game
    @window.show_all
    
    Gtk.main
  end
  
  def switchContext(newContext)
    #TODO
    return if @currentContext != nil && @currentContext == newContext
    @mainPanel.remove @mainPanel.child if @mainPanel.child != nil
    case newContext
    when :game
      if @game == nil
        @mainPanel.child = @newGameWidget
      else
        @mainPanel.child = @gameBoardWidget
      end
    when :account
      if !@controller.testConnection || @controller.clientSettings.sessionId.length < 1
        @mainPanel.child = @loginWidget
        updateLoginWidget ''
      else
        @mainPanel.child = @logoutWidget
        updateLogoutWidget
      end
    when :server
        @mainPanel.child = @serverWidget
        updateServerWidget ''
    when :stats
        @mainPanel.child = @statsWidget
        updateStatsWidget
    else
    end
    @currentContext = newContext
    @window.resize(1,1) #Window resizes to smallest possible w/ all components shown
    @window.show_all
  end
  
  # attempts to start game
  def startGame(boardControllerType)
    # sends options and create a custom boardController
    @bController = @controller.getBoardController(boardControllerType, @gameSettings)
    #TODO: start board
  end
  
  def initNewGameWidget
    @gameSettings = GameSettingsModel.new
    
    @newGameWidget = Gtk::VBox.new
    @newGameWidget.pack_start Gtk::Label.new "Welcome to Connect4.2!\nPractice in local mode:"
    players1 = Gtk::RadioButton.new "1"
    GtkHelper.applyEventHandler(players1, :clicked) {@gameSettings.players = 1}
    players2 = Gtk::RadioButton.new players1, "2"
    GtkHelper.applyEventHandler(players2, :clicked) {@gameSettings.players = 2}
    players = GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Players: " },
        { :widget => players1 },
        { :widget => players2 } ] )
    @newGameWidget.pack_start players
    
    victoryNormal = Gtk::RadioButton.new "Normal"
    GtkHelper.applyEventHandler(victoryNormal, :clicked) {@gameSettings.victoryType = 'victoryNormal'}
    victoryOtto = Gtk::RadioButton.new victoryNormal, "OTTO/TOOT"
    GtkHelper.applyEventHandler(victoryOtto, :clicked) {@gameSettings.victoryType = 'victoryOtto'}
    victory = GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Game Mode: " },
        { :widget => victoryNormal },
        { :widget => victoryOtto } ] )
    @newGameWidget.pack_start victory
    
    playButton = Gtk::Button.new "Play"
    GtkHelper.applyEventHandler(playButton, :clicked) {startGame 'local'}
    @newGameWidget.pack_start playButton
    @newGameWidget.pack_start Gtk::Label.new "Play online:"
    @serverGameListWidget = Gtk::Label.new "[server games go here]"
    @newGameWidget.pack_start @serverGameListWidget
  end
  
  def updateNewGameWidget
    if @controller.testConnection
      @serverGameListWidget = Gtk::Label.new "TODO: Server games list"
    else
      @serverGameListWidget = Gtk::Label.new "Connect to a server to play Connect4.2 online."
    end
  end
  
  def initGameBoardWidget
    @gameBoardWidget = Gtk::Label.new "TODO: Game board widget"
  end
  
  def initLoginWidget
    @loginWidget = Gtk::VBox.new
    usernameEntry = Gtk::Entry.new
    @loginWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Username: " },
        { :widget => usernameEntry } ] )
    passwordEntry = Gtk::Entry.new
    @loginWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Password: " },
        { :widget => passwordEntry } ] )
    loginButton = Gtk::Button.new "Login"
    #TODO: add event handler
    @loginWidget.pack_start loginButton
    @loginResult = Gtk::Label.new ""
    @loginWidget.pack_start @loginResult
  end
  
  def updateLoginWidget(message)
    @loginResult.text = message
  end
  
  def initLogoutWidget
    @logoutWidget = Gtk::VBox.new
    @loggedInMessage = Gtk::Label.new "Logged in as [username]"
    button = Gtk::Button.new "Log out"
    GtkHelper.applyEventHandler(button, :clicked) {@controller.logout}
    @logoutWidget.pack_start @loggedInMessage
    @logoutWidget.pack_start button
  end
  
  def updateLogoutWidget
    #Called when newly logged in
    @loggedInMessage.text = "Logged in as " + @controller.clientSettings.username
  end
  
  def initServerWidget
    @serverWidget = Gtk::VBox.new
    addressEntry = Gtk::Entry.new
    addressEntry.text = @controller.clientSettings.host + ":" + @controller.clientSettings.port.to_s
    #TODO: add event handler
    @serverWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Server Address: " },
        { :widget => addressEntry } ] )
    connectButton = Gtk::Button.new "Connect"
    #TODO: add event handler
    @serverWidget.pack_start connectButton
    @serverConnectionResult = Gtk::Label.new ""
    @serverWidget.pack_start @serverConnectionResult
  end
  
  def updateServerWidget(message)
    #Update serverConnectionResult based on how the server connected
    @serverConnectionResult.text = message
  end
  
  def initStatsWidget
    @statsWidget = Gtk::VBox.new
    @statsWidget.pack_start Gtk::Label.new "Top Player Stats:"
    @topPlayerStatsWidget = Gtk::Label.new "[database stats go here]"
    @statsWidget.pack_start @topPlayerStatsWidget
    @statsWidget.pack_start Gtk::Label.new "Your Stats:"
    @yourStatsWidget = Gtk::Label.new "[player stats go here]"
    @statsWidget.pack_start @yourStatsWidget
  end
  
  def updateStatsWidget
    if controller.testConnection
      @topPlayerStatsWidget.text = "TODO: top player stats"
    else
      @topPlayerStatsWidget.text = "Connect to a server to see top player stats."
    end
    if controller.testConnection && @controller.clientSettings.sessionId.length >= 1
      @yourStatsWidget.text = "TODO: your stats"
    else
      @yourStatsWidget.text = "Log in or sign up to see your stats."
    end
  end
end