require 'test/unit'
require 'socket'
require_relative '../../lib/client/model/client-settings'
require_relative '../../lib/common/model/game-settings'
require_relative '../../lib/common/model/game'
require_relative '../../lib/client/controller/menu'
require_relative '../../lib/server/server'
require_relative '../../lib/server/database/database'

class ServerTest < Test::Unit::TestCase
  
  $acc1 = {:username => 'test1', :password => 'test1pass'}
  $acc2 = {:username => 'test2', :password => 'test2pass'}
  
  def setup
    port = 50500
    
    @server1 = Server.new(port)
    @port1 = @server1.port
    @server1.start
    
    @server2 = Server.new(@port1 + 1)
    @port2 = @server2.port
    @server2.start
    
    @removes = []
    @removes.push(['Player', $acc2[:username]])
    @removes.push(['Player', $acc1[:username]])
    doRemoval
    
    sleep 1 # make sure servers are running
    startClients
  end

  def teardown
    doRemoval
    @server1.close
    @server2.close
    @client1.close
    @client2.close
  end
  
  def doRemoval
    db = Database.new
    @removes.each do |pair|
      db.remove(pair[0], pair[1])
    end
  end
  
  def startClients
    #start the client1 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port1
    @client1 = MenuController.new(sett)
    @client1.connect
    puts 'STARTED CLIENT1'
      
    # start the client2 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port2
    @client2 = MenuController.new(sett)
    @client2.connect
    puts 'STARTED CLIENT2'
    
    @client1.createPlayer($acc2[:username], $acc2[:password])
    @client1.createPlayer($acc1[:username], $acc1[:password])
    puts 'CLIENT1 CREATED ACCOUNTS'

    @client2.login($acc2[:username], $acc2[:password])
    puts 'CLIENT2 LOGGED IN'
  end
  
  def test_playGame
   
    gSett = GameSettingsModel.new(2, 'victoryNormal')
    @board1 = @client1.getBoardController('online', gSett)
    gameId = @board1.implementation.gameId
    @removes.push(['Game', gameId])
    puts 'GOT CLIENT1 BOARD CONTROLLER'
    
    games = @client2.getGames    
    puts 'GOT GAMES'
    
    @board2 = @client1.getBoardController('online', gameId)
    puts 'GOT CLIENT2 BOARD CONTROLLER'
    
    @refresh1 = Proc.new { |data|
        assert data.class == GameModel
    }
    @refresh2 = Proc.new { |data|
        assert data.class == GameModel
    }
    
    @board1.registerRefresh(@refresh1)
    @board2.registerRefresh(@refresh2)
    puts 'REGISTERED REFRESHES'
    
    @refresh1 = Proc.new { |data|
      assert false
    }
    
    @board1.placeToken(1)
    
  end
 
  
end