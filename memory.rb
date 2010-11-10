module Memory
  def remember_retreating_from(direction)
    @retreated_from ||= []
    @retreated_from << direction
  end

  def forget_retreats_from_previous_space
    @retreated_from ||= []
    @retreated_from.clear
  end

  def bad_idea_to_go?(direction)
    @retreated_from ||= []
    @retreated_from.include? direction
  end
end
