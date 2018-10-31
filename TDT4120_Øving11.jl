# Øving 11 TDT4120

function floyd_warshall(adjacency_matrix, nodes, f, g)
    d = copy(adjacency_matrix)
    for k in 1:nodes
        for i in 1:nodes
            for j in 1:nodes
                d[i, j] = f(d[i, j], g(d[i, k], d[k, j]))
            end
        end
    end
    return d
end


function transitive_closure(adjacency_matrix, nodes)
    boolean_matrix = zeros(Int, nodes, nodes)
    for i in 1:nodes
        for j in 1:nodes
            if adjacency_matrix[i, j] != Inf
                boolean_matrix[i, j] = 1
            end
        end
    end
    return floyd_warshall(boolean_matrix, nodes, |, &)
end


transitive_closure2(adjacency_matrix, nodes) = floyd_warshall(map(a -> (a != Inf) ? 1 : 0, adjacency_matrix), nodes, |, &)


function create_preference_matrix(ballots, voters, candidates)
    preference_matrix = zeros(Int32, candidates, candidates)
    for ballot in ballots
        for (i, candidate) in enumerate(ballot) # Ballots are "candidates" long
            candidate_index = candidate - 'A' + 1
            for j in i+1:candidates # All lower placed candidates
                lower_candidate_index = ballot[j] - 'A' + 1
                preference_matrix[candidate_index, lower_candidate_index] += 1
            end
        end
    end
    return preference_matrix
end


function find_strongest_paths(preference_matrix, candidates)
    for i in 1:candidates
        for j in 1:candidates
            if preference_matrix[i,j] > preference_matrix[j,i]
                preference_matrix[j,i] = 0
            else
                preference_matrix[i,j] = 0
            end
        end
    end
    return floyd_warshall(preference_matrix, candidates, max, min)
end


function find_schulze_ranking(strongest_paths, candidates)
    for i in 1:candidates
        for j in 1:candidates
            if strongest_paths[i, j] > strongest_paths[j, i]
                strongest_paths[j, i] = 0
            else
                strongest_paths[i, j] = 0
            end
        end
    end
    ranking = Vector{Char}(undef, candidates)
    for i in 1:candidates
        rank = sum(iszero.(strongest_paths[i, :]))
        ranking[rank] = Char(i - 1 + 'A')
    end
    return String(ranking)
end


adjacency_matrix = [0 7 2; Inf 0 Inf; Inf 4 0]
ballots = ["ABC", "CBA", "BAC", "ABC"]
preference_matrix = [0 0 20 0; 19 0 0 0; 0 21 0 17; 16 18 0 0]#[0 1 2; 2 0 2; 1 1 0;]
strongest_paths = [0 20 20 17; 19 0 19 17; 19 21 0 17; 18 18 18 0]#[0 0 2; 2 0 2; 0 0 0]

println(floyd_warshall(adjacency_matrix, 3, min, +))
println(transitive_closure(adjacency_matrix, 3))
println(create_preference_matrix(ballots, 3, 3))
println(find_strongest_paths(preference_matrix, 4))
println(find_schulze_ranking(strongest_paths, 4))
