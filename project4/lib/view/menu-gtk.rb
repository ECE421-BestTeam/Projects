require 'gtk2'
require_relative './gtk-helper'
require_relative './board'
require_relative '../controller/menu'

# should not contain any logic as it is the view
class MenuGtk
  
  # creates the board and sets the listeners
  def initialize(boardViewType, menuControllerType)
    @boardViewType = boardViewType
    
    # the menu options
    @handler = MenuController.new menuControllerType

    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      Gtk.main_quit
    end
    @window.title = "Connect4.2 Menu"
#    window.border_width = 10
    
    showMenu
    
    Gtk.main
  end
  
  # attempts to start game
  def startGame
    # sends options and create a custom boardController
    bController = @handler.getBoardController
    
    # start a board view
    BoardView.new(@boardViewType, bController) do |model|
      # exit game callback
    end
  end
  
  # shows the menu and allows the user set options
  def showMenu
#    @window.remove @windowContent
    menu = Gtk::VBox.new
    
    # build options and listeners
       
    players1 = Gtk::RadioButton.new "1"
    players1.signal_connect(:clicked) {@players = 1}
    players2 = Gtk::RadioButton.new players1, "2"
    players2.signal_connect(:clicked) {@players = 2}
    players = GtkHelper.createBox('H', 
      [
        {
          :type => Gtk::Label,
          :content => "Players: "
        },
        {
          :widget => players1
        },
        {
          :widget => players2
        }
      ]
    )
    menu.pack_start players
    
    victoryNormal = Gtk::RadioButton.new "Normal"
    victoryNormal.signal_connect(:clicked) {@victoryType = 0}
    victoryOtto = Gtk::RadioButton.new victoryNormal, "OTTO/TOOT"
    victoryOtto.signal_connect(:clicked) {@victoryType = 1}
    victory = GtkHelper.createBox('H', 
      [
        {
          :type => Gtk::Label,
          :content => "Game Mode: "
        },
        {
          :widget => victoryNormal
        },
        {
          :widget => victoryOtto
        }
      ]
    )
    menu.pack_start victory
    
    start = GtkHelper.createBox('H', 
      [
        {
          :type => Gtk::Button,
          :content => "Start Game!",
          :listeners => [
            { 
              :event => :clicked, 
              :action => Proc.new {startGame} 
            }
          ]
        }
      ]
    )
    menu.pack_start start
    
    #refresh the menu's values
    
    if @players == 2
      players1.set_active false
      players2.set_active true
    else
      #default
      players1.set_active true
      players2.set_active false
      @players = 1
    end
    
    if @victoryType == 1
      victoryNormal.set_active false
      victoryOtto.set_active true
    else
      #default
      victoryNormal.set_active true
      victoryOtto.set_active false
      @victoryType = 0
    end
    
    @menu = menu
    @window.add @menu
    
    @window.show_all

  end
  
end