require 'benchmark'

REGEXP = /^43\d{7}$/
arr_set = Set.new
arr = (1..660000).to_a.each do |code|
  arr_set.add { code: code, name: "name-#{code}" }
end

puts arr_set.size
Benchmark.bmbm(1000) do |t|
  t.report do
    arr_set.select! do |item|
      REGEXP =~ item['code']
    end
  end
end