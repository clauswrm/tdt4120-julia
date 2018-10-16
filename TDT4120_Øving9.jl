# Øving 9 TDT4120

mutable struct DisjointSetNode
    rank::Int
    p::DisjointSetNode
    DisjointSetNode() = (obj = new(0); obj.p = obj;)
end


function findset(x::DisjointSetNode)
    if x.p != x
        x.p = findset(x.p)
    end
    return x.p
end


# Samme som over, på en linje
findset2(x) = (x.p == x) ? x : x.p = findset(x.p)

function link(x, y)
    if x.rank > y.rank
        y.p = x
    else
        x.p = y
        if x.rank == y.rank
            y.rank += 1
        end
    end
end


union!(x::DisjointSetNode, y::DisjointSetNode) = link(findset(x), findset(y))

hammingdistance(s1::String, s2::String) = (length(s1) == 0) ? 0 : sum(c -> (c[1] == c[2]) ? 0 : 1, zip(s1, s2))

function findclusters(E::Vector{Tuple{Int, Int, Int}}, n::Int, k::Int)
    nodes = [DisjointSetNode() for i in 1:n]
    sort!(E)
    no_clusters = n
    for (w, u, v) in E
        if no_clusters == k
            break
        end
        if findset(nodes[u]) != findset(nodes[v])
            union!(nodes[u], nodes[v])
            no_clusters -= 1
        end
    end
    clusters = Dict{DisjointSetNode, Vector{Int}}()
    for i in 1:n
        node = findset(nodes[i])
        cluster = get!(clusters, node, Vector{Int}())
        push!(cluster, i)
    end
    return collect(Vector{Int}, values(clusters))
end


function findanimalgroups(animals::Vector{Tuple{String, String}}, k::Int64)
    E = Vector{Tuple{Int, Int, Int}}()
    for i in 1:length(animals)
        for j in 1:i-1
            push!(E, (hammingdistance(animals[i][2], animals[j][2]), i, j))
        end
    end
    clusters = findclusters(E, length(animals), k)
    return [[animals[i][1] for i in cluster] for cluster in clusters]
end


# Fordi det funker, selvom det er idiotisk
findanimalgroups2(animals, k) = [[animals[i][1] for i in cluster] for cluster in findclusters([(hammingdistance(animals[u][2], animals[v][2]), u, v) for u in 1:length(animals) for v in 1:length(animals)], length(animals), k)]


e = [(3,1,2),(2,1,3),(4,2,3)]
println(findclusters(e, 3, 2))

a = [("Spurv", "CCATTCGT"), ("Mus", "TAGGCATA"), ("Elg", "CCGGATTA"), ("Hjort", "CCGGAATA"), ("Ugle", "GGATTCGG"), ("Hamster", "TAGGCAGG"), ("Marsvin", "TAGGCATG"), ("Hauk", "GGATGCGG")]
println(findanimalgroups(a, 3))
