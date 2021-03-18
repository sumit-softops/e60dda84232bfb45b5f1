class Array
  def has_naked_multiple?(value)
    self.select { | a | (a-value).empty? }.size == value.size
  end
end