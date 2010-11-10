module Senses
  def hear_ticking?
    entities = @warrior.listen
    entities.find { |c| c.ticking? } != nil
  end

  def surrounded?
    num_unbound_enemies_near_me > 1
  end

  def enemy_in_my_path?
    @warrior.feel(@desired_direction).enemy?
  end

  def feel_captive?
    (direction_of_captive_next_to_me != nil).tap do |see|
      say "I do #{see ? "" : "not"} see a captive!"
    end
  end

  def can_avoid_combat?
    say "I'm in trouble!  Can I get out of here?"
    !alternative_directions.empty?
  end

  def enemies_are_unbound?
    direction_of_unbound_enemy != nil
  end

  def captive_next_to_me?
    direction_of_captive_next_to_me != nil
  end

  def direction_of_ticking
    entities = @warrior.listen
    ticking = entities.find { |c| c.ticking? }
    if ticking
      return @warrior.direction_of ticking
    end
    nil
  end

  def distance_of_ticking
    entities = @warrior.listen
    ticking = entities.find { |c| c.ticking? }
    if ticking
      return @warrior.distance_of ticking
    end
  end

  def enemies_in_direction_of_ticking?
    @warrior.look(direction_of_ticking)[0,2].any? { |s| s.enemy? } 
  end

  def enemies_2_deep_in_direction_of_ticking?
    @warrior.look(direction_of_ticking)[0,2].all? { |s| s.enemy? } 
  end
end
