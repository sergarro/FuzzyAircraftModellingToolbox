function mfplot( mf,varname )
%% Description
%This function plot membership functions of fuzzy model
%% Input
%   mf: membership function matrix
%   var: string with the variable name
%% Code
n=size(mf);
points=1000;
x=zeros(n(1),points);
if exist('varname','var')
    name=['of ',varname];
    v=varname;
else
    name=[];
    v='k';
end

for i=1:n(1)
x(i,:)=(mf(i,3):(mf(i,2)-mf(i,3))/(points-1):mf(i,2));
end

M=calcmf(mf,x',n(1));
names=fieldnames(M);
for i=1:n(1)
   tipo=mf(i,1);
   subplot(n(1),1,i)
   plot(x(i,:)',M.(names{i}))
   title(['Membership function of type ',num2str(tipo),' ',name])
   
   switch tipo
       case 1
            legend(['M_{',v,'}^1'],['M_{',v,'}^2'])
            xlabel('\alpha(t) [rad]'),ylabel('M [-]')
       case 2
           legend(['E_{',v,'}^1'],['E_{',v,'}^2'])
            xlabel('\beta(t) [rad]'),ylabel('E [-]') 
       case 3
           legend(['F_{',v,'}^1'],['F_{',v,'}^2'])
            xlabel('\sqrt{x(t)}'),ylabel('F [-]')
       case 4
           legend(['N_{',v,'}^1'],['N_{',v,'}^2'])
            xlabel('x_1(t)/x_2(t) [-]'),ylabel('N [-]')
       case 5
           legend(['G_{',v,'}^1'],['G_{',v,'}^2'])
            xlabel('e^{-x(t)} [-]'),ylabel('G [-]')
       case 6
           legend(['H_{',v,'}^1'],['H_{',v,'}^2'])
            xlabel('x(t) [unknown]'),ylabel('H [-]')
       case 7
           legend(['J_{',v,'}^1'],['J_{',v,'}^2'])
            xlabel('x(t) [unknown]'),ylabel('J [-]')
   end
end
    
end

