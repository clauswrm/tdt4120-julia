# Øving 4 TDT4120

function counting_sort_letters(A, position)
    count = zeros(Int32, 26)
    for str in A
        count[Int(str[position]) - 96] += 1
    end
    for i in 2:length(count)
        count[i] += count[i-1]
    end
    sorted = Array{String,1}(undef,length(A))
    for j in length(A):-1:1
        k = Int(A[j][position]) - 96
        sorted[count[k]] = A[j]
        count[k] -= 1
    end
    return sorted
end

function counting_sort_letters2(A, position)
    count = zeros(Int32, 27)
    for str in A
        k = position > length(str) ? 1 : Int(str[position]) - 95
        count[k] += 1
    end
    for i in 2:length(count)
        count[i] += count[i-1]
    end
    sorted = Array{String,1}(undef,length(A))
    for j in length(A):-1:1
        k = position > length(A[j]) ? 1 : Int(A[j][position]) - 95
        sorted[count[k]] = A[j]
        count[k] -= 1
    end
    return sorted
end

function counting_sort_length(A)
    max_length = maximum(map(length, A))

    count = zeros(Int32, max_length + 1)
    for str in A
        count[length(str) + 1] += 1
    end
    for i in 2:length(count)
        count[i] += count[i-1]
    end
    sorted = Array{String,1}(undef,length(A))
    for j in length(A):-1:1
        k = length(A[j]) + 1
        sorted[count[k]] = A[j]
        count[k] -= 1
    end
    return sorted
end

function counting_sort_length2(A, max_length)
    count = zeros(Int32, max_length + 1)
    for str in A
        count[length(str) + 1] += 1
    end
    for i in 2:length(count)
        count[i] += count[i-1]
    end
    sorted = Array{String,1}(undef,length(A))
    for j in length(A):-1:1
        k = length(A[j]) + 1
        sorted[count[k]] = A[j]
        count[k] -= 1
    end
    return sorted
end

function flexradix(A, max_length)
    A = counting_sort_length2(A, max_length)
    for pos in max_length:-1:1
        A = counting_sort_letters2(A,  pos)
    end
    return A
end

l = ["bd", "ab", "b", "cbcb", "abs"]
println(flexradix(["kobra", "aggie", "agg", "kort", "hyblen"], 6))
