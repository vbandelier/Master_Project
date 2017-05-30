x = -10:0.001:10
y = -10:0.001:-0.001
z = 0.001:0.001:10

plot(x,model3.levyf(x))
hold on
plot(y,model3.levyf(y))
plot(z,model3.levyf(z))
xlim([-10 10])
