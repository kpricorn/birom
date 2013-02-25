require 'birom/common'

module Birom
  class Graphics

    # TODO: review and fixme
    def self.getOutline(grid)
      edges = {}
      grid.triangles.each do |_c, t|
        v = t.getVertices
        [[v[0], v[1]], [v[0], v[2]], [v[1], v[2]]].each do |a, b|
          sorted = [a, b].sort_by{ |c| "#{c[:x]}/#{c[:y]}" }
          key = "#{sorted[0][:x]}/#{sorted[0][:y]} #{sorted[1][:x]}/#{sorted[1][:y]}"
          edges[key] ||= {start: sorted[0], end: sorted[1], counter: 0}
          edges[key][:counter] += 1
        end
      end

      validVertices = {}
      validEdges = {}
      edges.values.select{|l| l[:counter] == 1}.each do |edge|
        first = edge[:start]
        last = edge[:end]
        key_a = "#{first[:x]}/#{first[:y]}"
        validVertices[key_a] = first
        key_o = "#{last[:x]}/#{last[:y]}"
        validVertices[key_o] = last
        validEdges["#{first[:x]}/#{first[:y]} #{last[:x]}/#{last[:y]}"] = true
        validEdges["#{last[:x]}/#{last[:y]} #{first[:x]}/#{first[:y]}"] = true
      end

      if validVertices.empty?
        return []
      end

      vertices = []
      c = validVertices.keys.first
      first = validVertices[c]
      validVertices.delete(c)
      vertices << first

      Common.bfs first do |node|
        neighbours = []
        (-1..1).each do |_x|
          (-1..1).each do |_y|
            nb = validVertices["#{node[:x] + _x}/#{node[:y] + _y}"]
            if not nb.nil? and validEdges["#{node[:x]}/#{node[:y]} #{nb[:x]}/#{nb[:y]}"]
              vertices << nb
              validVertices.delete("#{node[:x] + _x}/#{node[:y] + _y}")
              neighbours << nb
              break
            end
          end
        end
        neighbours
      end

      vertices
    end
  end
end
