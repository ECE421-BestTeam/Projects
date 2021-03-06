require 'test/unit/assertions'

module MenuControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @clientSettings.class == ClientSettingsModel, "settings must be a ClientSettingsModel"
  end
  
  def pre_initialize(settings)
    assert settings.class == ClientSettingsModel, "settings must be a ClientSettingsModel"
  end

  def post_initialize
  end
  
  def pre_getBoardController(type, settings)
    assert ['local', 'online'].include?(type), "boardController type must be in ['local', 'online']"
    assert settings.class == GameSettingsModel || settings.class == String, "gameSettings must be a GameSettingsModel or game ID String, not #{settings.class}"
  end
  
  def post_getBoardController(result)
    assert result != nil, "boardController exist"
  end
    
end