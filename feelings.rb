module Feelings
  def sick_of_running?
    @annoyance >= 0
  end

  def safe?
    (num_unbound_enemies_near_me == 0).tap do |safe|
      say "I #{safe ? "" : "do not "}feel safe now."
    end
  end

  def wounded?
    (@warrior.health < @max_health / 2).tap do |wounded|
      say "But OUCH!" if wounded
    end
  end
end
