require 'test/unit/assertions'
require_relative './game-settings'
require_relative './victory'

module GameContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @settings.class == GameSettingsModel, "settings must be a GameSettingsModel, not a #{@settings.class}"
    assert @winner.class == Fixnum &&[0,1,2,3].include?(@winner), "winner must be a Fixnum.  0=noWinner, 1=player1, 2=player2, 3=draw."
    assert @victory.class == VictoryModel, "victory must be a VictoryModel"
    assert @turn.class == Fixnum && @turn >= 0, "turn must be a Fixnum greater than or equal to 0"
    msg = "board must be an array (size greater than 0) of arrays (of equal sizes, greater than 0)."
    assert @board.class == Array && @board.size > 0, msg
    board.each do |row| 
      assert row.class == Array && row.size > 0, msg
    end
  end
    
  def pre_initialize(settings)
    assert settings.class == GameSettingsModel, "settings must be a GameSettingsModel, not a #{@settings.class}"
  end
  
  def post_initialize
  end
  
  def pre_placeToken(col)
    assert col.class == Fixnum && col.between?(0, @settings.cols - 1), "col must be a Fixnum in range 0-#{@settings.cols - 1}"
  end
  
  def post_placeToken(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
  def pre_computerTurn
  end
  
  def post_computerTurn(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
  def pre_waitForNextUpdate(currentTurn)
    assert currentTurn.class == Fixnum && currentTurn >= 0, "currentTurn must be a Fixnum greater than or equal to 0"
  end
  
  def post_waitForNextUpdate(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
  def pre_checkVictory
  end
  
  def post_checkVictory(result)
    assert result.class == Fixnum &&[0,1,2,3].include?(result), "winner must be a Fixnum.  0=noWinner, 1=player1, 2=player2, 3=draw."
  end
  
end