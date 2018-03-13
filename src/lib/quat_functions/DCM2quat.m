function [ qba ] = DCM2quat( Rba )
%This function convert director cosine rotation matrix to a quaternion
% vector wich transform  a vector on a system A, to a vector on a System B

%% Input
% Rba : Transformation square matrix (on 3D system is 3x3)

%% Output
% qba : Quaternion transformation vector (4x1)

%% Function
qs=sqrt(0.25*(1+Rba(1,1)+Rba(2,2)+Rba(3,3)));
qx=sqrt(0.25*(1+Rba(1,1)-Rba(2,2)-Rba(3,3)));
qy=sqrt(0.25*(1-Rba(1,1)+Rba(2,2)-Rba(3,3)));
qz=sqrt(0.25*(1-Rba(1,1)-Rba(2,2)+Rba(3,3)));

qba1=[qs;qx;qy;qz];

[num,ind]=max(qba1)

switch (ind)
   
    case 1
       qs=num;
       qx=Rba(3,2)-Rba(2,3);
       qy=Rba(1,3)-Rba(3,1);
       qz=Rba(2,1)-Rba(1,2);
    case 2
       qs=Rba(3,2)-Rba(2,3);
       qx=num;
       qz=Rba(1,3)+Rba(3,1);
       qy=Rba(2,1)+Rba(1,2);
    case 3
       qz=Rba(3,2)+Rba(2,3);
       qy=num;
       qs=Rba(1,3)-Rba(3,1);
       qx=Rba(2,1)+Rba(1,2);
    case 4
       qy=Rba(3,2)+Rba(2,3);
       qz=num;
       qx=Rba(1,3)+Rba(3,1);
       qs=Rba(2,1)-Rba(1,2);
end

qba=[qs*4*num;qx;qy;qz]/(4*num);
end

