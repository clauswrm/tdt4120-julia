# Øving 13 TDT4120

function certifysubsetsum(set, subsetindices, _sum)
    tot = 0
    for index in subsetindices
        tot += set[index]
    end
    return tot == _sum
end


certifysubsetsum2(set, subsetindices, _sum) = _sum == sum(si -> set[si], subsetindices)


function certifytsp(path, maxweight, neighbourmatrix)
    if path[1] != path[end]
        return false
    elseif !allunique(path[1:end-1])
        return false
    elseif length(path) != size(neighbourmatrix, 1) + 1
        return false
    end
    weight_sum = 0
    for i in 2:length(path)
        weight_sum += neighbourmatrix[path[i-1], path[i]]
    end
    return weight_sum <= maxweight
end

# Don't try this at home kids
certifytsp2(path, maxweight, neighbourmatrix) = (path[1] == path[end]) && allunique(path[1:end-1]) && (length(path) == size(neighbourmatrix, 1) + 1) && (sum(i -> neighbourmatrix[path[i-1], path[i]], 2:length(path)) <= maxweight)


function alldistinct(list)
    sort!(list)
    for i in 2:length(list)
        if list[i-1] == list[i]
            return false
        end
    end
    return true
end


alldistinct2(list) = length(unique(list)) == length(list)


function cliquetovertexcover(neighbourmatrix, minimumcliquesize)
    newneighbourmatrix = .!neighbourmatrix # Invert all bools (elementwise not)
    maximumvertexcoversize = size(neighbourmatrix, 1) - minimumcliquesize
    return newneighbourmatrix, maximumvertexcoversize
end


cliquetovertexcover2(neighbourmatrix, minimumcliquesize) = .!neighbourmatrix, size(neighbourmatrix, 1) - minimumcliquesize
