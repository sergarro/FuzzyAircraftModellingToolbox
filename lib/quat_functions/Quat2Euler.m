function [ phi,theta,psi ] = Quat2Euler( Q )
%Transform quaternions on euler angle
phi=atan2(2*(Q(:,3).*Q(:,4)+Q(:,1).*Q(:,2)),Q(:,4).^2-Q(:,3).^2-Q(:,2).^2+...
    Q(:,1).^2);
theta=-asin(2*(Q(:,2).*Q(:,4)-Q(:,1).*Q(:,3)));
psi=atan2(2*(Q(:,3).*Q(:,2)+Q(:,1).*Q(:,4)),-Q(:,4).^2-Q(:,3).^2+Q(:,2).^2+...
    Q(:,1).^2);
end

