@show 1 + 1

macro myshow(expression)
    quote
        value = $expression
        println($(Meta.quot(expression)), " = ", value)
        value
    end
end

x = @myshow 1+1
x


macro until(condition, expression)
    quote
        while !($condition)
            $expression
        end
    end |> esc
end

macro until(condition, expression)
    esc(quote
        while !($condition)
            $expression
        
        end
    end)
end


global i = 0 ;

@until i == 10 begin
    println(i)
    global i += 1
end

QuoteNode(:x)
Meta.quot(:x)
Expr(:quote, :x)

macro mysym2(); Meta.quot(:x); end

@mysym2

ex = :( x = 1; :($x + $x) )
quote
    x = 1
    $(Expr(:quote, :($(Expr(:$, :x)) + $(Expr(:$, :x)))))
end

eval(ex)

macro makeex(arg)
    quote
        :( x = $(esc($arg)); :($x + $x) )
    end
end

@makeex 1
@makeex 1 + 1

macro makeex2(arg)
    quote
        :( x = $$(Meta.quot(arg)); :($x + $x) )
    end
end

@makeex2 1 + 1

@makeex2 1 + $(sin(1))

let q = 0.5
    @makeex2 1 + $q
end



macro makeex3(arg)
    quote
        :( x = $$(QuoteNode(arg)); :($x + $x) )
    end
end
@makeex3 1 + $(sin(1))

let q = 0.5
    @makeex3 1 + $q
end

eval(@makeex3 $(sin(1)))

macro makeex4(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$$(Meta.quot(left)) + $$$(Meta.quot(right)))
        end
    end
end
@makeex4 x=1 x x
eval(ans)
@makeex4 x=1 x/2 x
eval(ans)


macro makeex5(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$(Meta.quot($(Meta.quot(left)))) + $$(Meta.quot($(Meta.quot(right)))))
        end
    end
end

@makeex5 x=1 1/2 1/4
eval(ans)
#result: :(1 / 2 + 1 / 4)
@makeex5 y=1 $y $y
#result: ERROR: UndefVarError: y not defined

macro makeex6(expr, left, right)
    quote
        quote
            $$(Meta.quot(expr))
            :($$(Meta.quot($(QuoteNode(left)))) + $$(Meta.quot($(QuoteNode(right)))))
        end
    end
end

@makeex6 y=1 1/2 1/4
eval(ans)
@makeex6 y=1 $y $y
eval(ans)
@makeex6 y=1 1+$y $y
eval(ans)
@makeex6 y=1 $y/2 $y
eval(ans)



macro assert(ex)
    return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
end

@assert 1 == 1.0
@assert 1 == 0

@macroexpand @assert a == b

@macroexpand @assert a==b "a should equal b!"

@assert a==b "a ($a) should equal b ($b)!"

macro decorator(dec, func)
    name = func.args[1].args[1]
    hiddenname = gensym()
    func.args[1].args[1] = hiddenname
    quote
      $func
      const $(esc(name)) = $dec($hiddenname)
    end
end

foo(f) = x->2*f(x+10)

@decorator foo function bar(x)
    return x+1
end

#http://julia-programming-language.2336112.n4.nabble.com/Macro-as-decorators-td40521.html