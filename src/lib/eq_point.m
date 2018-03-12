    function p_eq = eq_point(deriv,out,flightpar,states,ins,flight)
% Finds the numeric solution to the equilibrium points of the model given
% the flight parameters.
% Inputs:
%   - deriv     : 1st order ODE
%   - out       : output equations
%   - states    : symbolic array of states
%   - ins       : symbolic array of inputs
%   - flight    : symbolic array of dlight conditions
%   - flightpar : numerical flight conditions
% Outputs:
%   - p_eq      : equilibrium point (states_0,inputs_0)
    

% Valores en equilibrio
% {p,q,r,phi,psi,v}   = [0 0 0 0 0 0]
% {Windx,Windy,Windz} = [flightpar.WX 0 0]
% {delta_a,delta_r}   = [0 0]
% Hlg                 = flightpar.Z
% Vc                  = flightpar.VC

symb_pars = num2cell([flight,states(7:10),states(12),states(5),ins(5:7),ins(2),ins(4)]);
symb_vals = [flightpar.MASS,flightpar.XCG,flightpar.gamGLD,flightpar.T0,flightpar.WX,flightpar.altRWY,flightpar.gamRWY,0 0 0 0 0 0 flightpar.WX 0 0 0 0]; 
deriv0    = vpa(subs(deriv,symb_pars,symb_vals));
out0      = vpa(subs(out,symb_pars,symb_vals));

% Solve
epr=ins(1);theta=states(11);delta_e=ins(3);u=states(4);w=states(6);z=states(3);x=states(1);y=states(2);
sol     = vpasolve([deriv0(4) deriv0(6) deriv0(8) out0(1)-flightpar.VC out0(2)*tand(abs(flightpar.gamK))+out0(3) out0(7)-flightpar.Z],[epr,theta,delta_e,u,w,z],[0.95 1.6;0 1;-0.43 0.43; 0 Inf;nan nan;nan nan],'random',true);

out0    = subs(out0,{epr,delta_e,u,w,theta,z},[sol.epr,sol.delta_e,sol.u,sol.w,sol.theta,sol.z]);
sol.x   = solve(out0(4)-flightpar.dZ,x);
sol.y   = solve(out0(5)-flightpar.dY,y);


p_eq=double([sol.x,sol.y,sol.z,sol.u,0,sol.w,0,0,0,0,sol.theta,0,sol.epr,0,sol.delta_e,0,flightpar.WX,0,0]);

end