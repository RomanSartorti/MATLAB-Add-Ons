function yout = newtons(fh,y0,opt)
%% Simple Newton-Raphson method.
    if nargin < 3
        opt.maxNewtonIter = 1000;
        opt.Tol = 1e-15;
        opt.FinalJacobianOut = false;
        opt.JacobianPreDefined = false;
        opt.FinDiffStep = 1e-10;
    end

    e = 1;
    y = y0;
    count = 0;
    delta = opt.FinDiffStep ;

    F = fh(y) ;

    while e > opt.Tol && count < opt.maxNewtonIter
        J = zeros(length(y0),length(y0));

        %% Estimate Jacobian via finite differences:
        for i = 1: length(y0)
            dy = zeros(length(y0),1);
            dy(i) = delta;
            fp = fh(y+dy);
            fn = fh(y-dy);
            J(:,i) = (fp-fn)/(2*delta);
        end
        yold = y;
        y = y - J\F;

        F = fh(y);
       
        e = norm(y-yold);
%         e = max(abs(F));
        count = count +1;
        if (count == opt.maxNewtonIter)
            warning('Newton seems to find no minimum')
        end
    end
    if opt.FinalJacobianOut
        disp('final Jacobian=');
        disp(J);
    end
    yout = y;
end
