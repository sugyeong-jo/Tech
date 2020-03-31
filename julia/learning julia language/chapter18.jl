# chapter 18
```
for i = I # or "for i in I"
    # body
end

state = start(I)
while !done(I, state)
    (i, state) = next(I, state)
    # body
end
```

struct Foo
    bar::Array{Int,1}
end
I = Foo([1,2,3])
I.bar

for i in I.bar
    println(i)
end

start(I::Foo) = 1
next(I::Foo, state) = (I.bar[state], state+1)
function done(I::Foo, state)
    if state == length(I.bar)
        return true
    end
    return false
end

state = start(I)
while !done(I, state)
    (i, state) = next(I, state)
    println(i, state)    
end

import Base.Iterators: take, drop, cycle
lazysub(itr, r::UnitRange) = take(drop(itr, first(r) - 1), last(r) - first(r) + 1)

collect(lazysub("abcde", 2:3))

circshift(1:10, 3)

import Base.Iterators: take, drop, cycle
lazycircshift(itr, n) = take(drop(cycle(itr), length(itr) - n), length(itr))
String(collect(lazycircshift("Hello, World!", 3)))

map(prod, Base.product(1:10, 1:10))


##lazily
import Base: getindex

struct Lazy
    thunk
    value
    Lazy(thunk) = new(thunk)    
end 

evaluate!(lazy::Lazy) = (lazy.value = lazy.thunk(); lazy.value)
getindex(lazy::Lazy) = isdefined(lazy, :value) ? lazy.value : evaluate!(lazy)

import Base: first, tail, start, next, done, IteratorSize, HasLength, SizeUnknown
abstract type List end

mutable struct Cons <: List
    head
    tail::Lazy
end 


mutable struct Nil <: List end

macro cons(x, y)
    quote
        Cons($(esc(x)), Lazy(() -> $(esc(y))))
    end
end

first(xs::Cons) = xs.head
tail(xs::Cons) = xs.tail[]
start(xs::Cons) = xs
next(::Cons, xs) = first(xs), tail(xs)
done(::List, ::Cons) = false
done(::List, ::Nil) = true
IteratorSize(::Nil) = HasLength()
IteratorSize(::Cons) = SizeUnknown()

xs = @cons(1, ys)
ys = @cons(2, xs)
[Base.Iterators.take(xs, 5)...]