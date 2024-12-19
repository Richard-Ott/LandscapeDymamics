%% More basic matlab: Introduction to loops
 
%% The most commonly used loop is a for-loop. 
% This type of loop can be used when the number of iterations is known
% before the loop starts. For example
for i = 1:0.5:10
    j = i^2
end
 
% be aware that i is a predefined Matlab variable for the imaginary unit
% (e.g. i^2 = -1). When it is recast in this way in the forloop it can no
% longer be used so it is better to use another variable.
 
% it is also recommended to predefine the size of the variable created
% inside the loop because it speeds up execution of the loop.
 
%% lets try another look and make a basic plot of the results. 
 
x = 0:0.1:10;   % the semicolon suppresses the output. Use it!
j = zeros(size(x));     % this makes a vector of zeros the size of x.
 
for iloop = 1:length(x)
    j(iloop) = x(iloop)^2;
end
 
plot(x,j)
 
%% you can change plot options. Let’s plot x versus j as red dots
 
plot(x,j,'ro');
 
%% you can keep plots from clearing by using "hold on" and allow then to
% clear with "hold off". For example
 
plot(x,j,'k-'); hold on
plot(x,j,'gv'); hold off
 
%% a different kind of loop is a while-loop.
% this type of loop will repeat until certain criterion is fulfilled.
 
y = 0;
while y < 22
    y = y + 1;
    disp(['y is equal to ', num2str(y)])
end
 
%% this is also a good point to get to know Boolean or logical operators.
% the result of a Boolean operator is 1 for true or 0 for false.
% the Boolean operators are:
 
% a == b    a is equal to b
% a < b     a is less than b
% a <= b    a is less than or equal to b
% a > b     a is greater than b
% a >= b    a is greater than or equal to b
% a ~= b    a is not equal to b
 
% Boolean operators can be combine with "or" and "and".
 
% a == b & c <= d   an example of an "and" statement.
% a == b | c <= d   an example of an "or" statement.
 
% other useful logical operators include
 
% isnan(a)      is "a" not a number (nan)? 
% isinf(a)      is "a" infinitely large? 
% isreal(a)     is "a" a real number?
 
%% Logical indexing
% logical indexing using Boolean (aka logical) operators is a useful way to
% select specific elements from a matrix or vector
 
t = magic(5)   % this will create a 5 x 5 matrix of integers from 1 - 5^2
 
%% look at the output from t > 20. Remember 0 is false and 1 is true
t > 20
 
%% lets see what the numbers satisfy t > 20
t(t > 20)
 
% this process of using a logical statement to index into a matrix or
% vector is called logical indexing.
%%
clear
clc
 
%% if, else and switch statement
% Using Boolean operators we can use if, else and switch statements to
% decide if matlab executes a command. For example,
r = 7;
if r > 5
    b = 1;
else
    b = 50;
end
 
%% we can use these statements in loops to change an operation. for example
 
for j = 1:10
    x = randi(50);  % this will generate a random integer from 1 to 50
    if x <=25
        disp('x <= 25');
    else
        disp('x > 25');
    end
end
 
%% if more than two options are needed, you can use the switch command.
 
s = 4;
switch s
    case 2
        b = 0
    case 1
        b = 1
    case 4
        b = 99
    case 70
        b = 3
end