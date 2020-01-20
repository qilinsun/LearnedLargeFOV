function out = MygenerateCheckerboardPoints(m,n,L)
p = 0;
out = zeros((m-1)*(n-1),2);
for i = 0:1:(n-2)
    for j = 0:1:(m-2)
        p = p+1;
        out(p,:) = [-L*i,-L*j];
    end
end
