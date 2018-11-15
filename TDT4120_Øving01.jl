# Øving 1 TDT4120

function insertionsort!(list)
    i = 1
    while i <= length(list)
        j = 1
        while j <= i
            if list[i] < list[j]
                list[i], list[j] = list[j], list[i]
            end
            j += 1
        end
        i += 1
    end
end

lst = [8,5,8,3,2,3,5,9]
insertionsort!(lst)
println(lst)
