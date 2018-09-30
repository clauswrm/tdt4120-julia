# Øving 6 TDT4120

# For teorioppgavene
using Memoize # Må lastes ned med 'using Pkg; Pkg.add("Memoize")'

# Matrisetraversering
@memoize T(x,y) = (x > 1 && y > 1) ? T(x-1,y) + T(x,y-1) : 1
# Rod-cut
@memoize R(p,n) = (n == 0) ? 0 : maximum(map(i -> R(p,n-i)+p[i], collect(1:n)))

# Praksisoppgaver

function cumulative(weights)
    cumulative_weights = copy(weights)

    for y in 2:size(weights, 1)
        for x in 1:size(weights, 2)
            _min = cumulative_weights[y-1, x]
            if (x > 1)
                _min = min(_min, cumulative_weights[y-1, x-1])
            end
            if (x < size(weights, 2))
                _min = min(_min, cumulative_weights[y-1, x+1])
            end
            cumulative_weights[y, x] += _min
        end
    end
    return cumulative_weights
end


function back_track(weights)
    path = Array{Tuple{Int, Int}, 1}()
    height, width = size(weights, 1), size(weights, 2)

    lower, upper = 1, width
    for y in height:-1:1
        min_x = findmin(view(weights, y, lower:upper))[2] + lower - 1
        push!(path, (y, min_x))
        lower, upper = max(1, min_x - 1), min(width, min_x + 1)
    end
    return path
end

# Alternativ versjon
function back_track2(weights)
    path = Array{Tuple{Int, Int}, 1}()

    prev_x = findmin(view(weights, 5,:))[2] # Minste elements index
    push!(path, (size(weights, 1), prev_x))

    for y in size(weights, 1)-1:-1:1
        min_x = prev_x
        if (prev_x > 1 && weights[y, prev_x-1] <= weights[y, min_x])
            min_x = prev_x-1
        end
        if (prev_x < size(weights, 2) && weights[y, prev_x+1] < weights[y, min_x])
            min_x = prev_x+1
        end
        push!(path, (y, min_x))
        prev_x = min_x
    end
    return path
end

weights = [3  6  8 6 3;
           7  6  5 7 3;
           4  10 4 1 6;
           10 4  3 1 2;
           6  1  7 3 9]

path_weights = cumulative(weights)
path = back_track(path_weights)
println(path)
