# My warrior is named "Marshall" in honor of the evil bastard who coaxed me into playing this game.  
# This way, I get to see Marshall die again and again as I test him against each level
# 
# Clearly, after three levels of modifications, the Player class could use some refactoring

include RubyWarrior::Units

require 'behaviors'
require 'feelings'
require 'memory'

class Player
  include Feelings
  include Behaviors
  include Memory

  def say(remark)
    puts "Marshall says, \"#{remark}\""
  end 

  def play_turn(warrior)
    @warrior = warrior
    @annoyance ||= 0
    @max_health ||= @warrior.health
    @past_direction = @desired_direction

    choose_direction_toward_objective

    if hear_ticking?
      act_toward_ceasing_ticking!
    elsif captive_next_to_me?
      @warrior.rescue! direction_of_captive_next_to_me
    elsif safe?
      rest_or_move!
    elsif surrounded? 
      fight_or_escape!
    elsif wounded?
      run_away!
    elsif enemy_in_my_path? 
      face_the_peril!
    else
      @warrior.walk! @desired_direction
    end
  end

  def choose_direction_toward_objective
    entities = @warrior.listen
    captives = entities.select { |e| e.unit.is_a? Captive }
    ticking = captives.find { |c| c.ticking? }

    @desired_direction = if hear_ticking?
        @warrior.direction_of(ticking).tap do |dir|
          say "I hear ticking coming from #{dir}"
        end
      elsif !captives.empty?
        @warrior.direction_of(captives.first).tap do |dir|
          say "A captive is somewhere #{dir} of me"
        end
      else
        @warrior.direction_of_stairs.tap do |dir|
          say "The stairs are #{dir} of me"
        end
      end
  end
end
