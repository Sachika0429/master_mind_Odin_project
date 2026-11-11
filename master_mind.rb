module MasterMind
  class Game
    def initialize
      @colors = ['red', 'blue', 'yellow', 'green', 'black', 'white']
      @selected_colors = Array.new(4) { @colors.sample }

      @turn_num = 1

      @player_answer = Array.new(4)
      @answer_history = Array.new(12)

      @hit = Array.new(12, 0)
      @blow = Array.new(12, 0)

      @player = Player.new(self)

    end

    attr_reader :colors, :turn_num, :player_answer, :answer_history, :selected_colors

    def play

      loop do

        if @turn_num > 12
          puts "You lost. The answer is: #{@selected_colors}"
          print_answer_history
          return
        end

        @player_answer = Array.new(4)
        @player.select_colors
        compare_colors

        if has_player_won?(@hit[@turn_num - 1])
          puts "Correct! You won. The answer is: #{@selected_colors}"
          puts
          puts "Here is your answer history ↓↓↓\n"
          puts
          print_answer_history
          return
        end

        print_answer_history

        @turn_num += 1
      end
    end

    def compare_colors

      @copied_answer = @player_answer.dup
      @copied_selected_colors = @selected_colors.dup

      @selected_colors.each_with_index do |color, i|
        if color == @player_answer[i]
          @hit[@turn_num - 1] += 1
          @copied_answer[i] = nil
          @copied_selected_colors[i] = nil
        end
      end

      @copied_answer.compact!
      @copied_selected_colors.compact!

      @copied_selected_colors.each do |copied_color|
        if @copied_answer.include?(copied_color)
          @blow[@turn_num - 1] += 1
          @copied_answer.delete_at(@copied_answer.index(copied_color))
        end
      end

    end

    def has_player_won?(hit)
      if hit == 4
        return true
      end
    end

    def print_hit_and_blow(turn)
      puts "#{@hit[turn - 1]} hit, #{@blow[turn - 1]} blow"
    end

    def print_answer_history

      @count = 1

      loop do

        if @turn_num >= 13
          return
        end

        puts "TURN #{@count}: #{@answer_history[@count - 1]}"
        print_hit_and_blow(@count)
        puts

        if @count == @turn_num
          return
        end

        @count += 1

      end
    end

  end

  class Player

    def initialize(game)
      @game = game
    end

    def select_colors

      @index = 0

      loop do
        print "TURN #{@game.turn_num}: Guess 4 colors from #{@game.colors}\n => "

        loop do

          if @index > 4
            return
          end

          answer = gets.chomp

          if !@game.colors.include?(answer)
            print "#{answer} does not exist in the option. Try again.\n"
            break
          else 
            @game.player_answer[@index] = answer
            @index += 1
          end

          if !@game.player_answer.include?(nil)
            @game.answer_history[@game.turn_num - 1] = @game.player_answer.dup
            return @game.player_answer
          end
        end

      end

    end

  end
end

include MasterMind
game = Game.new

game.play