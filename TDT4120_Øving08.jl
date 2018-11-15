# Øving 8 TDT4120

using DataStructures

mutable struct Node
    id::Int
    neighbours::Array{Node}
    color::Union{String, Nothing}
    distance::Union{Int, Nothing}
    predecessor::Union{Node, Nothing}
end
Node(id) = Node(id, [], nothing, nothing, nothing)


function makenodelist(adjacencylist)
	nodes = Node[]
	# Oppretter n noder
    for n in 1:length(adjacencylist)
		push!(nodes, Node(n))
	end
	# Legger til noders naboer
	for i in 1:length(adjacencylist)
		for neighbour in adjacencylist[i]
			push!(nodes[i].neighbours, nodes[neighbour])
		end
	end
	return nodes
end


function bfs!(nodes, start)
	for node in nodes
		node.color = "white"
		node.distance = typemax(Int) # Uendelig
	end
	start.color = "gray"
	start.distance = 0
	queue = Queue{Node}()
	enqueue!(queue, start)
	while !isempty(queue)
		current = dequeue!(queue)
		if isgoalnode(current)
			return current
		end
		for neighbour in current.neighbours
			if neighbour.color == "white"
				neighbour.color = "gray"
				neighbour.distance = current.distance + 1
				neighbour.predecessor = current
				enqueue!(queue, neighbour)
			end
		end
		current.color = "black"
	end
end


makepathto(goalnode) = (goalnode == nothing) ? Int[] : push!(makepathto(goalnode.predecessor), goalnode.id)
