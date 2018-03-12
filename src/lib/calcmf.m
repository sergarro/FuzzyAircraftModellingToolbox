function [ M ] = calcmf(mf,x,n)
%% Description
% Returns membership value

%% Inputs
% mf : membership matrix of the FIS struct
% x  : membership input.
% n  : number of membership types.
%% Outputs
% M  : Membsership value.
%% Code
M=[];
for i=1:n
   tipo=mf(i,1);
   st=cellstr(['mf',num2str(i)]);
   switch tipo
       case 1 %arctan form
           if x(:,i)==0
            M.(st{1})=[1,0];    
           else
            M.(st{1})=[x(:,i)./tan(x(:,i)),...
           (tan(x(:,i))-x(:,i))./tan(x(:,i))];
           end
       case 2 %arcsin form
           if x(:,i)==0
            M.(st{1})=[1,0];    
           else
       M.(st{1})=[(x(:,i)-sin(x(:,i)))./(pi/2*sin(x(:,i))-sin(x(:,i))),...
                  (pi/2*sin(x(:,i))-x(:,i))./(pi/2*sin(x(:,i))-sin(x(:,i)))]; 
           end
       case 3 %sqrt(x) form
       M.(st{1})=[sqrt(x(:,i))/(mf(i,2)),...
           (mf(i,2)*ones(length(x(:,i)),1)-sqrt(x(:,i)))/(mf(i,2))];    
       case 4 %x1/x2 or x^2 or A+B*x form
       M.(st{1})=[(x(:,i)-mf(i,3)*ones(length(x(:,i)),1))/(mf(i,2)-mf(i,3)),...
           (mf(i,2)*ones(length(x(:,1)),1)-x(:,i))/(mf(i,2)-mf(i,3))];
       case 5 %exp(-x) form
       M.(st{1})=[x(:,i)./(ones(length(x(:,i)),1)+log(x(:,i))),...
           (ones(length(x(:,i)),1)+log(x(:,i))-x(:,i))./(ones(length(x(:,i)),1)+log(x(:,i)))];
       case 6
       M.(st{1})=[(x(:,i)-mf(i,3)*ones(length(x(:,i)),1))/(mf(i,2)-mf(i,3)),...
           (mf(i,2)*ones(length(x(:,1)),1)-x(:,i))/(mf(i,2)-mf(i,3))];
       case 7
       M.(st{1})=[(x(:,i)-mf(i,3)*ones(length(x(:,i)),1))/(mf(i,2)-mf(i,3)),...
           (mf(i,2)*ones(length(x(:,1)),1)-x(:,i))/(mf(i,2)-mf(i,3))];
   end
end

end

