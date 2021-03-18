class Hash
  def row(i) 
    self.select { | key, value | key[1].to_i == i}.values
  end
  def column(i) 
    self.select { | key, value | key[0].to_i == i}.values
  end
  def box(i) 
    self.select { | key, value | key[2].to_i == i}.values
  end
end