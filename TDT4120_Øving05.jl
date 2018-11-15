# Øving 5 TDT4120

struct Node
    children::Dict{Char,Node}
    posi::Array{Int}
end
Node() = Node(Dict(),[])

function parse_string(sentence::String)::Array{Tuple{String, Int}}
    current_index = 1
    out = Tuple{String, Int}[]
    while current_index <= length(sentence)
        start_word_index = findnext(l -> l != ' ', sentence, current_index)
        end_word_index = findnext(l -> l == ' ', sentence, start_word_index)
        if end_word_index == nothing
            end_word_index = length(sentence)
        else
            end_word_index -= 1
        end
        push!(out, (sentence[start_word_index:end_word_index], start_word_index))
        current_index = end_word_index + 1
    end
    return out
end

function build(list_of_words::Array{Tuple{String,Int}})::Node
    root = Node()
    current_node = root
    for word in list_of_words
        current_node = root
        for letter in word[1]
            current_node = get!(current_node.children, letter, Node())
        end
        push!(current_node.posi, word[2])
    end
    return root
end

function positions(word::String,node::Node,index::Int=1)::Array{Int}
    out = Int[]
    if length(word) < index
        append!(out, node.posi)
    elseif word[index] == '?'
        for (letter, child) in node.children
            append!(out, positions(word, child, index + 1))
        end
    elseif word[index] in keys(node.children)
        append!(out, positions(word, node.children[word[index]], index + 1))
    end
    return out
end

result = positions("ei", build(parse_string("en ei eie ei")))
println(build(parse_string("ha ha mons har en hund med moms hun er en hunn"))['h'])
