require 'feelings'
require 'senses'
require 'logic'

module Behaviors
  include Feelings
  include Senses
  include Logic

  def rest_or_move!
    if wounded?
      @warrior.rest!
    else
      space = @warrior.feel @desired_direction
      if space.empty?
        @warrior.walk! @desired_direction
      else 
        @warrior.attack! @desired_direction
      end
    end
  end

  def find_a_way_out!
    if can_avoid_combat?
      run_away!
    elsif feel_captive?
      @warrior.rescue! direction_of_captive_next_to_me
    end
  end

  def run_away!
    say "RUN AWAY!!!!"
    @annoyance += 1
    direction_idx = rand(alternative_directions.length)
    @warrior.walk! alternative_directions[direction_idx]
    say "I soiled my armor again..."
  end

  def face_the_peril!
    say "I will FACE the peril!"
    @annoyance = 0
    weakest_enemy, weakest_direction = weakest_enemy_and_direction
    say "The biggest wimp is a #{weakest_enemy} that is #{weakest_direction} of me"
    @warrior.attack! weakest_direction
  end

  def fight_or_escape!
    if captive_next_to_me?
      @warrior.rescue! direction_of_captive_next_to_me
    elsif enemies_are_unbound?
      @warrior.bind! direction_of_unbound_enemy
    elsif enemy_in_my_path?
      @warrior.attack! @desired_direction
    else 
      @warrior.walk! @desired_direction
    end
  end

  def act_toward_ceasing_ticking!
    if captive_next_to_me? && captive_next_to_me.ticking?
      @warrior.rescue! direction_of_captive_next_to_me
    elsif safe?
      if distance_of_ticking > 2 && @warrior.health < @max_health
        @warrior.rest!
      else
        @warrior.walk! direction_of_ticking
      end
    elsif enemy_in_my_path?
      clear_a_path!
    else
      @warrior.walk! direction_of_ticking
    end
  end

  def clear_a_path!
    if surrounded? && num_unbound_enemies_near_me > 1
      fight_or_escape!
    else 
      @warrior.look(direction_of_ticking)[0,2].all? { |s| s.enemy? }
      if distance_of_ticking < 2
        say "There's ticking and there are two enemies in my way: blast them!"
        @warrior.detonate! direction_of_ticking
      else
        say "The ticking captive is too close.  Have at you!"
        @warrior.attack! direction_of_ticking
      end
    end
  end
end
