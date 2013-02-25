module Birom
  class Common
    # Walks a breadth first search starting
    # from node 'root'. Gets a list of neighbour
    # coordinates by calling the neighbours callback.
    #
    # BFS algorithm:
    # create a queue Q
    # enqueue source onto Q
    # mark source
    # while Q is not empty:
    #     dequeue an item from Q into v
    #     for each edge e incident on v in Graph:
    #         let w be the other end of e
    #         if w is not marked:
    #             mark w
    #             enqueue w onto Q
    def self.bfs(root, &block)
      q = [root]
      max_iterations = 1000
      counter = 0
      until q.empty?
        if (counter += 1) == max_iterations
          raise Exception.new("Endless loop in BFS (#{counter} iterations)")
        end
        v = q.pop
        block.call(v).each do |w|
          q.unshift w
        end
      end
    end

    def self.isWithin(a, b, x)
      ([a.u, b.u].min..[a.u, b.u].max).member?(x.u) and
        ([a.v, b.v].min..[a.v, b.v].max).member?(x.v) and
        ([a.w, b.w].min..[a.w, b.w].max).member?(x.w)
    end
  end
end
