% Test Class Object
clc; clear; close;
centroid = [100 100];
size = 300;
color = 'blue';
a(1) = Objects;
a(1).Size = size;
a(1).Color = color;
a(1).Location = centroid;
disp(a(1));
a(2) = Objects;
a(2).Size = 1;
a(2).Color = 'red';
a(2).Location = [400 400];
disp(a(2));
a(1) = a(1).update(289,[200 200]);
disp(a(1));

