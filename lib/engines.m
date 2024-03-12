function [ deprdt ] = engines( t,epr,input_t,input_u,param )
deprdt=zeros(1,3);    
for i=1:3
        u=interp1(input_t,input_u,t);
        if (u-epr)/param.eng.tau>param.eng.RL
            deprdt=param.eng.RL; 
        elseif (u-epr)/param.eng.tau<-param.eng.RL
            deprdt=-param.eng.RL;
        else
            deprdt=(u-epr)/param.eng.tau;
        end
end

