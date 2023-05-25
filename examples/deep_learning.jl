# Flux Guide

## beginner 

using Flux, Statistics 

### fitting a line 
actual(x) = 4x + 2 

x_train, x_test = hcat(0:5...), hcat(6:10...)

y_train, y_test = actual.(x_train), actual.(x_test)

model = Dense(1 => 1)

model.weight

model.bias 

model(x_train)

loss(model, x, y) = mean(abs2.(model(x) .- y))

loss(model, x_train, y_train)

opt = Descent()

data = [(x_train, y_train)]

using Flux: train!
train!(loss, model, data, opt)

model.weight
model.bias


for epoch in 1:200
    train!(loss, model, data, opt)
  end


loss(model, x_train, y_train)

model.weight
model.bias

model(x_test)

y_test

### gradients and Layers 


f(x) = 3x^2 + 2x +1 

df(x) = gradient(f, x)[1]

df(2)

f(x, y) = sum((x .- y).^2); 
gradient(f, [2,1], [2,0])

nt = (a = [2,1], b = [2,0], c = tanh)

g(x::NamedTuple) = sum(abs2, x.a .- x.b)

g(nt)

dg_nt = gradient(g, nt)[1]

gradient((x, y) -> sum(abs2, x.a ./ y .- x.b), nt, [1,2]) 

gradient(nt, [1,2]) do x, y 
    z = x.a ./ y 
    sum(abs2, z .- x.b) 
end 


W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
  ŷ = predict(x)
  sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

gs = gradient(() -> loss(x, y), Flux.params(W, b))


W̄ = gs[W]

W .-= 0.1 .* W̄

loss(x, y) # ~ 2.5


W1 = rand(3,5)
b1 = rand(3)
layer1(x) = W1 * x .+ b1
W2 = rand(2,3)
b2 = rand(2)
layer2(x) = W2*x .+ b2


model2(x) = layer2(σ.(layer1(x)))
model2(rand(5))



model3 = Chain( Dense(10 => 5 , σ), 
                Dense(5 => 2), 
                softmax)

                