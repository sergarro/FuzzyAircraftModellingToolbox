function [ q ] = multquat( q1,q2 )
%This function resolve the product q of two quaternions
%q1 and q2
%% Input
% q1:first quaternion vector 4x1
% q2:second quaternion vector 4x1

%% Output
% q: product of two quaternion, vector 4x1

%% function
s1=q1(1);
s2=q2(1);

v1=q1(2:4);
v2=q2(2:4);

s=s1*s2-dot(v1,v2);
v=s1*v2+s2*v1+cross(v1,v2);

q=[s;v];

end

