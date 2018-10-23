# Øving 10 TDT4120

using DataStructures: PriorityQueue, enqueue!, dequeue!


mutable struct Node
    ip::Int
    neighbours::Array{Tuple{Node,Int}}
    risk::Union{Float64, Nothing}
    predecessor::Union{Node, Nothing}
    probability::Float64
end
Node(ip, probability) = Node(ip, [], nothing, nothing, probability)


function initialize_single_source!(graph::Vector{Node}, start::Node)
    for node in graph
        node.risk = typemax(Float64)
        node.predecessor = nothing
    end
    start.risk = 0
end


function relax!(from_node::Node, to_node::Node, cost::Int)
    risk_for_edge = cost / to_node.probability
    if to_node.risk > from_node.risk + risk_for_edge
        to_node.risk = from_node.risk + risk_for_edge
        to_node.predecessor = from_node
    end
end


function dijkstra!(graph::Vector{Node}, start::Node)
    initialize_single_source!(graph, start)
    queue = PriorityQueue{Node, Float64}()
    for node in graph
        enqueue!(queue, node, node.risk)
    end
    while !isempty(queue)
        current_node = dequeue!(queue)
        for (neighbour, cost) in current_node.neighbours # For each edge from node
            old_risk = neighbour.risk
            relax!(current_node, neighbour, cost)
            if neighbour.risk != old_risk
                queue[neighbour] = neighbour.risk # Update priority
            end
        end
    end
end


function bellman_ford!(graph::Vector{Node}, start::Node)
    initialize_single_source!(graph, start)
    for i in 1:length(graph)-1
        for node in graph
            for (neighbour, cost) in node.neighbours # For all edges
                relax!(node, neighbour, cost)
            end
        end
    end
    for node in graph
        for (neighbour, cost) in node.neighbours # For all edges
            if neighbour.risk > node.risk + (cost / neighbour.probability)
                return false
            end
        end
    end
    return true
end


nodes = [Node(1, 0.9), Node(2, 0.8), Node(3, 0.7)]
push!(nodes[1].neighbours, (nodes[2], 5))
push!(nodes[1].neighbours, (nodes[3], 8))
push!(nodes[2].neighbours, (nodes[3], 4))

dijkstra!(nodes, nodes[1])
