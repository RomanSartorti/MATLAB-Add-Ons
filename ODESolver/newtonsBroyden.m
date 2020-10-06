function yout = newtonsBroyden(fh,y0,opt)
%% Simple Newtons method.
    if nargin < 3
        opt.maxNewtonIter = 1000;
        opt.Tol = 1e-15;
        opt.FinalJacobianOut = false;
        opt.JacobianPreDefined = false;
        opt.FinDiffStep =1e-8;
    end

    e = 1;
    y = y0;
    count = 0;
    delta = opt.FinDiffStep ;

    fm = fh(y) ;
    JF0 = zeros(length(y0),length(y0));

    %% Estimate first Jacobian via central differences:
    for i = 1: length(y0)
        dy = zeros(length(y0),1);
        dy(i) = delta;
        fp = fh(y+dy);
        fn = fh(y-dy);
        JF0(:,i) = (fp-fn)/(2*delta);
    end
    % Reassign intial values
    F0 = fh(y0);
    y = y0;
    JF = JF0;
    F = F0;

    % Optimize until constraints are met.
    counter = 1;

    
    while e > opt.Tol && (counter <= opt.maxNewtonIter)
        s = -JF \ F;
        
        yold = y;
        % new solution
        y = y + s;

        % current function value
        F = fh(y);
        dF = (fh(y)-fh(y-s));
        
        % Approximate Jacobian with Broydens "good" method.    
        dJ = (dF-JF*s)*s'/norm(s)^2;
        JF = JF + dJ;
        
        e = norm(y-yold);
%         e = norm(F-fh(y-s));
%         e = max(abs(F));
        counter = counter + 1;
    end

    % Output result
    yout = y(:);
end