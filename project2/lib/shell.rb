require './shell_handlers.rb'

module CustomShell
  
  def run
    loop do
      cmdArgs = parseInput(gets)
      if cmdArgs.size < 1
        puts "Please enter a command."
        next
      else
        interpret(cmdArgs)
      end
    end
  end

  def parseInput(command)
    return command.strip.split(' ')
  end

  def interpret(args)
    #This case statement will contain all commands and calls to handlers
    case args[0]
    when 'exit'
      if args.size == 1
        exit 0
      else
        puts "exit takes 0 arguments."
      end
    else
      ShellHandlers.masterHandler(args)
    end
  end
end
