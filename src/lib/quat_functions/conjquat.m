function [ conj_q] = conjquat(q)
%This function resolve the quaternion conjugate.

%% Input
% q: Original quaternion vector 4x1
%% Ouput
% conj_q: The conjugate quaternion vector 4x1

%% Function

conj_q=[q(1);-q(2);-q(3);-q(4)];

end

