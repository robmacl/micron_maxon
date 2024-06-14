% Given two rays, P1 + u1 and P2 + u2, return the point of approximate
% convergence of the rays and the distance of closest convergence (e.g. error)
% If the rays diverge or are parallel, return false, otherwise true.
%
% At the point of closest approach, the two rays are joined by a line that is
% normal to both rays.  The length of the line is the error.  We represent
% the endpoints of this line as:
%    M1 = lambda_1 * u1 + P1
%    M2 = lambda_2 * u2 + P2
%
% We then solve for lambda_1 and lambda_2 using reasonably simple formulas
% that I don't understand the derivation of.
%
function [res] = find_intersection(P1, u1, P2, u2)
P1 = P1(1:3);
u1 = u1(1:3);
P2 = P2(1:3);
u2 = u2(1:3);

denom = 1 - dot(u1, u2)^2;

lambda_1 = dot(P2 - P1, u1 - (u2 * dot(u1, u2))) / denom;
lambda_2 = dot(P2 - P1, (u1 * dot(u1, u2)) - u2) / denom;

M1 = (u1 * lambda_1) + P1;
M2 = (u2 * lambda_2) + P2;
alpha_v = M2 - M1;
res = [M1 + (alpha_v * 0.5), norm(alpha_v)];
