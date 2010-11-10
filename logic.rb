module Logic
  DIRECTIONS = [:forward, :left, :backward, :right]

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

  def perpendicular_direction_to(direction)
    DIRECTIONS[(DIRECTIONS.index(direction) + 3) % 4]
  end

  def direction_of_unbound_enemy
    unbound_dirs = []
    (DIRECTIONS - [@desired_direction]).each do |non_path_direction|
      unit = @warrior.feel(non_path_direction).unit
      if unit && !unit.bound?
        return non_path_direction
      end
    end
    return nil
  end

  def direction_of_captive_next_to_me
    result = nil
    DIRECTIONS.each do |dir|
      space = @warrior.feel dir
      if space.unit.is_a? Captive || space.unit.ticking?
        result = dir
        break
      end
    end
    result.tap do |dir|
      say "There's a captive #{dir} of me" if dir
    end
  end

  def captive_next_to_me
    DIRECTIONS.each do |dir|
      space = @warrior.feel dir
      if space.unit.is_a? Captive || space.ticking?
        return space
      end
    end
    nil
  end
end
