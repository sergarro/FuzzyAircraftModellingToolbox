function [ invq ] = invquat( q )
%This function resolve the inverse of a quaternion

%% Input
% q: quaternion vector 4x1;

%% Output
% invq: the inverse of quaternion vector q, 4x1

%% function

invq=conjquat(q)/(norm(q));


end

