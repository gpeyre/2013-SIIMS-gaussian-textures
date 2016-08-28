function [intersect_1,intersect_2] = intersect_circles(A,B,a,b)

% intersect_circles - find the interesection of two circles
%
%   [intersect_1,intersect_2] = intersect_circles(A,B,a,b);
%
%   A,B are the center (2D vectors or complex number)
%   a,b are the radius.
%
%   Copyright (c) 2011 Gabriel Peyre


use_cpx = 0;
if length(A)==1
    use_cpx = 1;
    A = [real(A) imag(A)];
    B = [real(B) imag(B)];
end

[xout,yout]=circcirc(A(1),A(2),a,B(1),B(2),b);

if use_cpx
    intersect_1 = xout(1)+1i*yout(1);
    intersect_2 = xout(2)+1i*yout(2);
end


function [xout,yout]=circcirc(x1,y1,r1,x2,y2,r2) 
 
%CIRCCIRC  Find the intersections of two circles in cartesian space 
% 
%  [xout,yout] = CIRCCIRC(x1,y1,r1,x2,y2,r2) finds the points 
%  of intersection (if any), given two circles, each defined by center 
%  and radius in x-y coordinates.  In general, two points are 
%  returned.  When the circles do not intersect or are identical, 
%  NaNs are returned.  When the two circles are tangent, two identical 
%  points are returned.  All inputs must be scalars. 
% 
%  See also LINECIRC 
 
%  Copyright 1996-2002 Systems Planning and Analysis, Inc. and The MathWorks, Inc. 
%  Written by:  E. Brown, E. Byrns 
%   $Revision: 1.10 $    $Date: 2002/03/20 21:24:55 $ 
 
if nargin ~= 6;  error('Incorrect number of arguments');  end 
 
%  Input consistency test 
 
if ~isequal(size(x1),size(y1),size(r1),size(x2),size(y2),size(r2),[1 1]) 
	     error('Inputs must be scalars') 
elseif ~isreal([x1,y1,r1,x2,y2,r2]) 
		error('inputs must be real') 
elseif r1==0 | r2==0 
		error('radius must be positive') 
end 
 
% Cartesian separation of the two circle centers 
 
r3=sqrt((x2-x1).^2+(y2-y1).^2); 
 
indx1=find(r3>r1+r2);  % too far apart to intersect 
indx2=find(r2>r3+r1);  % circle one completely inside circle two 
indx3=find(r1>r3+r2);  % circle two completely inside circle one 
indx4=find((r3<10*eps)&(abs(r1-r2)<10*eps)); % circles identical 
indx=[indx1(:);indx2(:);indx3(:);indx4(:)]; 
 
anought=atan2((y2-y1),(x2-x1)); 
 
%Law of cosines 
 
aone=acos(-((r2.^2-r1.^2-r3.^2)./(2*r1.*r3))); 
 
alpha1=anought+aone; 
alpha2=anought-aone; 
 
xout=[x1 x1]+[r1 r1].*cos([alpha1 alpha2]); 
yout=[y1 y1]+[r1 r1].*sin([alpha1 alpha2]); 
 
% Replace complex results (no intersection or identical) 
% with NaNs. 
 
if ~isempty(indx) 
    xout(indx,:) = NaN;    yout(indx,:) = NaN; 
end 