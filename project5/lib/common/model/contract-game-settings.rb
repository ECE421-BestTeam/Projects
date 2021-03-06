require 'test/unit/assertions'

module GameSettingsContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @players.class == Fixnum && @players.between?(1,2), "players must be a Fixnum in 1-2"
    assert @victoryType.class == String && ['victoryNormal', 'victoryOtto'].include?(@victoryType), "victoryType must be a String in ['victoryNormal', 'victoryOtto']"
    assert @rows.class == Fixnum && @rows > 0, "rows must be a Fixnum greater than 0"
    assert @cols.class == Fixnum && @cols > 0, "cols must be a Fixnum greater than 0"
  end
  
  def pre_players=(val)
    assert val.class == Fixnum && val.between?(1,2), "players must be a Fixnum in 1-2"
  end

  def pre_victoryType=(val)
    assert val.class == String && ['victoryNormal', 'victoryOtto'].include?(val), "victoryType must be a String in ['victoryNormal', 'victoryOtto']"
  end
  
  def pre_rows=(val)
    assert val.class == Fixnum && val > 0, "rows must be a Fixnum greater than 0"
  end
  
  def pre_cols=(val)
    assert val.class == Fixnum && val > 0, "cols must be a Fixnum greater than 0"
  end
  
end