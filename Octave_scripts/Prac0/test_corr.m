x = wavread('white_noise_sound.wav');
y = x;
r2 = corr(x,y) # note that in some versions, this is called "corr"

y(1) = 2; y(5) = -4; # i.e. fudge some of the value
r2 = corr(x,y)

x = rand(1,10); y = rand(1,10);
r2 = corr(x,y)

x = [0:0.1:0.1*10000];

x1 = x(1:100);
y1 = sin(x1);
x2 = x(11:110);
y2 = sin(x2);
x3 = x(1:1000);
y3 = sin(x3);
x4 = x(101:1100);
y4 = sin(x4);
x5 = x(1:10000);
y5 = sin(x3);
x6 = x(101:10100);
y6 = sin(x4);



r2 = corr(y1,y2)
r2 = corr(y3,y4)

