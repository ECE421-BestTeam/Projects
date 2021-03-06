require_relative './contract-board'
require_relative './board-local'

# board controller interface
class BoardController
  include BoardControllerContract
  
  #initializes the selected board controller
  def initialize (type, settings)
    pre_initialize(type, settings)
    
    case type
      when :boardControllerLocal
        @implementation = BoardLocalController.new settings
    end
    
    post_initialize
    class_invariant
  end

  def settings
    pre_settings
    
    result = @implementation.settings
    
    post_settings(result)
    class_invariant
    return result
  end
  
  def localPlayers
    pre_localPlayers
    
    result = @implementation.localPlayers
  
    post_localPlayers(result)
    class_invariant
    return result
  end
  
  # called after a user has completed all settings
  # returns GameModel successful
  def startGame
    pre_startGame
    
    result = @implementation.startGame
    
    post_startGame(result)
    class_invariant
    return result
  end
  
  # called when closing the game
  def close 
    pre_close
    
    result = @implementation.close
    
    post_close
    class_invariant
    return result
  end
    
  # sends a request to place a token
  def placeToken(col)
    pre_placeToken(col)
    
    result = @implementation.placeToken(col)
    
    post_placeToken(result)
    class_invariant
    return result
  end
  
  # returns the next model where it is a local player's turn
  def getNextActiveState
    pre_getNextActiveState
    
    result = @implementation.getNextActiveState
    
    post_getNextActiveState(result)
    class_invariant
    return result
  end
  
end