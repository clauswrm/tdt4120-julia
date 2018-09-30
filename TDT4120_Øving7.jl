# Øving 7 TDT4120

# Fordi 1-linjere er gøy
can_use_greedy(coins) = iszero(map(i -> coins[i] % coins[i+1], collect(1:length(coins)-1)))

function min_coins_greedy(coins, value)
	n = 0
	for coin in coins
		n += div(value, coin)
		value %= coin
    end
	return n
end

# Bottom-up
function min_coins_dynamic(coins, value)
	d = fill(typemax(Int), value)
    d[1] = 1
	for i in 2:value
		for coin in coins
            if i == coin
                d[i] = 1
			elseif i > coin
                d[i] = min(d[i], 1 + d[i - coin])
            end
        end
    end
	return d[value]
end


c1 = [1000,500,100,20,5,1] # greedy
c2 = [1000,300,50,18,6,1] # dp
c3 = [100,300,50,18,6,1] # dp
c4 = [1000,999,1] # dp
c5 = [240,60,12,6,2,1] # greedy

println(min_coins_greedy(c1, 1387))
println(min_coins_dynamic(c4, 4995))
