# My warrior is named "Marshall" in honor of the evil bastard who coaxed me into playing this game.  
# This way, I get to see Marshall die again and again as I test him against each level
# 
# Clearly, after three levels of modifications, the Player class could use some refactoring

class Player
  DIRECTIONS = [:forward, :left, :backward, :right]

  def say(remark)
    puts "Marshall says, \"#{remark}\""
  end 

  def play_turn(warrior)
    @warrior = warrior
    @desired_direction = warrior.direction_of_stairs
    @annoyance ||= 0
    @max_health ||= @warrior.health

    say "I want to go #{@desired_direction}"

    if safe?
      make_a_safe_choice!
    elsif surrounded? 
      if sick_of_running?
        fight_my_way_out!
      else
        find_a_way_out!
      end
    elsif enemy_in_my_path?
      fight_or_flight!
    else
      @warrior.walk! @desired_direction
    end
  end

  def make_a_safe_choice!
    if wounded?
      @warrior.rest!
    elsif see_captive?
      @warrior.rescue! direction_of_captive
    else
      @warrior.walk! @desired_direction
    end
  end

  def find_a_way_out!
    if can_avoid_combat?
      run_away!
    elsif see_captive?
      @warrior.rescue! direction_of_captive
    end
  end

  def fight_or_flight!
    if !sick_of_running? && can_avoid_combat? 
      run_away!
    else
      fight_my_way_out!
    end
  end

  def sick_of_running?
    @annoyance >= 3
  end

  def safe?
    enemy_count == 0
  end

  def surrounded?
    enemy_count > 1
  end

  def wounded?
    (@warrior.health < @max_health).tap do |wounded|
      say "But OUCH!" if wounded
    end
  end

  def enemy_in_my_path?
    @warrior.feel(@desired_direction).enemy?
  end

  def see_captive?
    direction_of_captive != nil
  end

  def can_avoid_combat?
    say "I'm in trouble!  Can I get out of here?"
    !alternative_directions.empty?
  end

  def run_away!
    say "RUN AWAY!!!!"
    @annoyance += 1
    direction_idx = rand(alternative_directions.length)
    @warrior.walk! alternative_directions[direction_idx]
    say "I soiled my armor again..."
  end

  def fight_my_way_out!
    say "I will FACE the peril!"
    @annoyance = 0
    weakest_enemy, weakest_direction = weakest_enemy_and_direction
    say "The biggest wimp is a #{weakest_enemy} that is #{weakest_direction} of me"
    @warrior.attack! weakest_direction
  end

  def weakest_enemy_and_direction
    remaining_directions = DIRECTIONS - [opposite_direction_of(@desired_direction)]
    weakest_enemy, weakest_direction = nil, nil
    remaining_directions.each do |direction|
      space = @warrior.feel(direction)
      next if space.wall?
      enemy = space.unit
      next if enemy.nil?
      if weakest_enemy.nil?
        weakest_enemy = enemy
        weakest_direction = direction
      elsif weakest_enemy.health > enemy.health
        weakest_enemy = enemy
        weakest_direction = direction
      end
    end
    [weakest_enemy, weakest_direction]
  end

  def enemy_count
    DIRECTIONS.inject(0) do |sum, dir|
      sum += 1 if @warrior.feel(dir).enemy?
      sum
    end
  end

  def direction_of_captive
    result = nil
    DIRECTIONS.each do |dir|
      if @warrior.feel(dir).captive?
        result = dir
      end
    end
    result
  end

  def alternative_directions
    remaining_directions = DIRECTIONS - [@desired_direction]
    say "Let's see whats in these directions: #{remaining_directions.inspect}"
    remaining_directions.inject([]) do |alternatives, alternative_direction|
      space = @warrior.feel(alternative_direction)
      if space.empty?
        alternatives << alternative_direction
      end
      alternatives
    end.tap do |alternatives|
      say "We can try these other directions: #{alternatives.inspect}"
    end
  end

  def opposite_direction_of(desired)
    DIRECTIONS[(DIRECTIONS.index(desired) + 2) % 4]
  end
end
