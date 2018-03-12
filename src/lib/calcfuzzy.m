function [ yout ] = calcfuzzy( fisvar,x,u )
%% Calc fuzzy output
% This  function  calculate  the  defuzyfication  using  the  FIS  struct 
% model  with  the  membershipfunctions and consequent matrix information
%% Input
% fisvar : FIS struct of the variable model with mfs and c matrix struct
% x      : Input variables of the membership functions
% u      : Input variables of the consequent functions (optional)
%% Output
% yout   : output of the defuzyfication.
%% Code
if exist('u','var')
    u1=u;
else
    u1=x;
end
rules=fisvar.r;
nmf=rules/2;
y=0;
sumM=0;

M=calcmf(fisvar.mf,x,nmf);
C=calcc(fisvar.c,u1,rules);
names=fieldnames(M);
i=1;
if nmf==2
        for j=1:2
            for k=1:2
            y=y+M.(names{1})(:,j).*M.(names{2})(:,k).*C(:,i);
            sumM=sumM+M.(names{1})(:,j).*M.(names{2})(:,k);
            i=i+1;
            end
        end

else
        for i=1:rules
            y=y+M.(names{1})(:,i).*C(:,i);
            sumM=sumM+M.(names{1})(:,i);
        end
end
yout=y./sumM;

end

