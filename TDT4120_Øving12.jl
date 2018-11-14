# Øving 12 TDT4120

using DataStructures: Queue, dequeue!, enqueue!

function find_augmenting_path(source, sink, nodes, flows, capacities)

  function create_path(source, sink, parent)
    # creates a path from source to sink using parent list
    node = sink
    path = Vector{Int}([sink])
    while node ≠ source
      node = parent[node]
      push!(path, node)
    end
    return reverse(path)
  end

  discovered = zeros(Bool, nodes)
  parent = zeros(Int, nodes)
  queue = Queue{Int}()
  enqueue!(queue, source)

  # BFS to find augmenting path, while keeping track of parent nodes
  while !isempty(queue)
    node = dequeue!(queue)
    if node == sink
      return create_path(source, sink, parent)
    end

    for neighbour ∈ 1:nodes
      if !discovered[neighbour] && flows[node, neighbour] < capacities[node, neighbour]
        enqueue!(queue, neighbour)
        discovered[neighbour] = true
        parent[neighbour] = node
      end
    end
  end

  return nothing # no augmenting path found
end

function max_path_flow(path, flows, capacities)
  # find max flow to send through a path
  n = length(path)
  flow = Inf
  for i in 2:n
    u, v = path[i-1], path[i]
    flow = min(flow, capacities[u, v] - flows[u, v])
  end
  return flow
end

function send_flow!(path, flow, flows)
  n = length(path)
  for i in 2:n
    u, v = path[i-1], path[i]
    flows[u, v] += flow
    flows[v, u] -= flow
  end
end


function max_flow(source, sink, nodes, capacities)
    total_flow = 0
    flows = zeros(Float64, nodes, nodes)
    augmenting_path = find_augmenting_path(source, sink, nodes, flows, capacities)
    while augmenting_path != nothing
        augmenting_flow = max_path_flow(augmenting_path, flows, capacities)
        total_flow += augmenting_flow
        send_flow!(augmenting_path, augmenting_flow, flows)
        augmenting_path = find_augmenting_path(source, sink, nodes, flows, capacities)
    end
    return flows, total_flow
end


function min_cut(source, sink, nodes, capacities)
    flows, total_flow = max_flow(source, sink, nodes, capacities)
    rest_flow_net = capacities - flows

    function bfs(start, neighbour_matrix)
        discovered = Int[]
        queue = Queue{Int}()
        enqueue!(queue, start)
        push!(discovered, start)
        while !isempty(queue)
            node = dequeue!(queue)
            for neighbour in 1:nodes
                if !(neighbour in discovered) && neighbour_matrix[node, neighbour] != 0
                    push!(discovered, neighbour)
                    enqueue!(queue, neighbour)
                end
            end
        end
        return discovered
    end

    S = bfs(source, rest_flow_net)
    T = Int[node for node in 1:nodes if !(node in S)]
    return  S, T
end


function find_trusted_cluster(trusted_peers, no_peers, network)
    flow_network = zeros(Float64, no_peers+2, no_peers+2) # Two more nodes, super-sink and -drain
    super_sink, super_drain = no_peers+1, no_peers+2

    for i in 1:no_peers
        for j in 1:no_peers
            flow_network[i, j] = network[i, j]
        end
    end
    for peer in 1:no_peers
        if peer in trusted_peers
            flow_network[super_sink, peer] = Inf
        else
            flow_network[peer, super_drain] = 1
        end
    end

    trusted, not_trusted = min_cut(super_sink, super_drain, no_peers+2, flow_network)
    filter!(peer -> peer != super_sink, trusted) # Remove super-sink
    return trusted
end


capacities = [0.0 16.0 13.0 0.0 0.0 0.0;
              16.0 0.0 4.0 12.0 0.0 0.0;
              13.0 4.0 0.0 9.0 14.0 0.0;
              0.0 12.0 9.0 0.0 7.0 20.0;
              0.0 0.0 14.0 7.0 0.0 4.0;
              0.0 0.0 0.0 20.0 4.0 0.0]

println(max_flow(1, 6, 6, capacities))
println(min_cut(1, 6, 6, capacities))

network = [0 0.7 0.9 0.1
           0.9 0 0.7 0.1
           0.5 0.5 0 0.5
           0.9 0.9 0.9 0]

println(find_trusted_cluster([1,2], 4, network))
