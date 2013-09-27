function dist = barycenter_dist(S,Si,lambda)


% transport_dist = @(S1,S2)abs( trace(S1 + S2 - 2*(S1^(1/2)*S2*S1^(1/2))^(1/2) ) );

dist = 0;
SS = S^(1/2);
for i=1:length(lambda)
    dist = dist + lambda(i) * trace(S + Si(:,:,i) - 2*(SS*Si(:,:,i)*SS)^(1/2) );
end
dist = abs(dist);