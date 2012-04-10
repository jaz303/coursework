def go(state, remain, bins)
  if remain == 0
    state[:count] += 1
    state[:matching] += 1 if bins.all? { |b| !b.empty? }
  else
    4.times do |i|
      bins[i].push true
      go(state, remain - 1, bins)
      bins[i].pop
    end
  end
end

tally = {:count => 0, :matching => 0}

go(tally, 12, [[], [], [], []])

p tally