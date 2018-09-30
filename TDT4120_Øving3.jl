# Øving 3 TDT4120

function bisect_right(A, p, r, v)
    i = p
    if p < r
       q = floor(Int, (p+r)/2)
       if v < A[q]
           i = bisect_right(A, p, q, v)
       else
           i = bisect_right(A, q+1, r, v)
       end
    end
    return i
end

function bisect_left(A, p, r, v)
    i = p
    if p < r
       q = floor(Int, (p+r)/2)
       if v <= A[q]
           i = bisect_left(A, p, q, v)
       else
           i = bisect_left(A, q+1, r, v)
       end
    end
    return i
end


function algdat_sort!(A)
    A[:] = merge_sort(A, 1, length(A)) # [:] er rar hack for å bytte ut alle elementene i listen
end

function merge_sort(lst, start, stop)
    if start == stop # Base case, range med lengde 1
        return [lst[start]]
    end
    mid = div((start + stop), 2)
    listA = merge_sort(lst, start, mid)
    listB = merge_sort(lst, mid + 1, stop)

    lenA,  mid - start + 1
    lenB = stop - mid
    indexA, indexB = 1, 1
	mergedList = []

    # Merge
	while indexA <= lenA && indexB <= lenB
		if listA[indexA] < listB[indexB]
			push!(mergedList, listA[indexA])
			indexA += 1
		else
			push!(mergedList, listB[indexB])
			indexB += 1
        end
    end

	while indexA <= lenA
		push!(mergedList, listA[indexA])
		indexA += 1
    end

	while indexB <= lenB
		push!(mergedList, listB[indexB])
		indexB += 1
    end
    return mergedList
end

function find_median(A, lower, upper)
    len = length(A)
    indexLow = bisect_left(A, 1, len, lower)
    indexHigh = bisect_right(A, 1, len + 1, upper) - 1
    indexMedian = div((indexLow + indexHigh), 2)
    if (indexLow + indexHigh) % 2 == 0
        return A[indexMedian]
    else
        return (A[indexMedian] + A[indexMedian + 1]) / 2
    end
end
