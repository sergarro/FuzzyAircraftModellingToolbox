   function yout = ode4(F,t0,h,tfinal,y0,input_t,input_u,param)
   % ODE4  Classical Runge-Kutta ODE solver.
   %   yout = ODE4(F,t0,h,tfinal,y0) uses the classical
   %   Runge-Kutta method with fixed step size h on the interval
   %      t0 <= t <= tfinal
   %   to solve
   %      dy/dt = F(t,y)
   %   with y(t0) = y0.

   %   Copyright 2014 - 2015 The MathWorks, Inc.
   
      y = y0;
      yout = y;
      for t = t0 : h : tfinal-h
         s1 = F(t,y,input_t,input_u,param);
         s2 = F(t+h/2, y+h*s1/2,input_t,input_u,param);
         s3 = F(t+h/2, y+h*s2/2,input_t,input_u,param);
         s4 = F(t+h, y+h*s3,input_t,input_u,param);
         y = y + h*(s1 + 2*s2 + 2*s3 + s4)/6;
         yout = [yout; y];
      end
