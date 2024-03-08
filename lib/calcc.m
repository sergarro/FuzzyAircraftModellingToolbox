function [ C ] = calcc(c,u,n)
%% Description
% This function calculate the consecuent for each input

%% Inputs
% n: number of consecuents (rules)
% u: input of consecuent (column vector)
% c: consequent struct
%% Outputs
% C: consequent result
%% Code
x=u(:,1);
C=zeros(length(x),n);
for i=1:n
tipo=c(i,1);
    if strcmp(tipo,'constant')
        C(:,i)=c{i,2}*ones(length(x),1);
    elseif strcmp(tipo,'lineal')
        C(:,i)=c{i,2}*x+c{i,3}*ones(length(x),1);
    else
        disp('This function only reconize constant and lineal consecuents')
    end
end

