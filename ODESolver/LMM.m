function [x,y,timeout] = LMM(fh,x,y0,schema, opt)
%LMM Function to evaluate a Linear Multistep Method (LMM) with a given
% scheme
% INPUT:
%   -   fh:     ODE function handle
%   -   x:      Vector with x-values (usually t)
%   -   y0:     Initial Values
%   -   Butcher:    (optional) Butcher Tableau either as matrix or as
%                   predefined struckt containing vectors Butcher.a [s by 1] ,
%                   matrix Butcher.B [s by s], vector Butcher.c [1 by s ]
%   -   opts:       (optional) Options struct
%       -   'FinalJacobianOut': states if the final Jacobian after
%                               Newton iteration should be displayed
%       -   'maxNewtonIter':    maximal steps for Newtons method
%       -   'Tol':              Tolerance for minimal value
%       -   'OptiOut':          Returns final value of F after finishing
%       -   'ButcherDisp':      Shows the Butcher Tableau used for the
%                               method
%       -   'Solver'            (default = Newton) solver to solve
%                               implicit methods ('Newton', 'fsolve')
%       -   'JacobianPreDefined' (default = false) says if Jacobian J is
%                               given by the input function [f,J]

    optfields={'FinalJacobianOut','maxNewtonIter','Tol','OptiOut',...
        'LMMDisp','Solver','JacobianPreDefined','FinDiffStep'};
    defaults = {false,10000,1e-8,false,false,'Newton',false,1e-10};
    if nargin < 5
        opt = [];
    end

    % Check for incoming options struct
    for iopt = 1:length(optfields)
        if isfield(opt,optfields{iopt})
            if isempty(opt.(optfields{iopt}))
                % Fills opts with input opts
                opt.(optfields{iopt}) = defaults{iopt};
            end
        else
            % Fills opts with defaults
            opt.(optfields{iopt}) = defaults{iopt};
        end
    end

    % Checkig if schema is given. If not, use default (Order 3)
    if nargin <4
        schema.a = [-1 1];
        schema.b = [1/2 1/2];
    end

    % Check if Butcher is already a struct, if not wrap the Matrix into a
    % struct with correct format.
    if ~isstruct(schema)
        schema = ButcherWraper(Butcher);
    end

    a = schema.a;
    b = schema.b;

    % consitency check
    consitency = consistencyCheck(a,b);
    if opt.LMMDisp
        disp(['Consitency p = ',num2str(consitency)])
    end
    % number of used steps
    s = length(a);
    k = s-1;

    %length of y
    ly = length(y0);
    y = zeros(length(x),length(y0))';
    y(:,size(y0,2)) = y0;
    h = diff(x);

    isimplicit = b(end)~=0;

        %%% Displaying Butcher as so desired
        if opt.LMMDisp
            fprintf('LMM Tableau is defined as:\n')
            fprintf('step | a | b\n-----\n\n LMM :\n')
            for idisp = 1:s
                fprintf('%.0f |',idisp-s)
                fprintf('%4.2f |',a(idisp))
                fprintf(' %4.2g',b(idisp)')
                fprintf('\n')
            end
            fprintf('------------------\n     | ')
        end

    % start timer
    tic
    %%%%%%%%%%% Estimation of first k-steps via explicit ode45 method %%%%%%%%%
    % to get a highly reliable result

    if size(y0,2)<s
        warning('Not enough initial values for all steps. Those will be estimated by an ode45 method.')
        temp = 0:h:(k)*h;
        %     [~,y_initial] = ode45(fh,temp,[1]);
        [~,y_initial_test] = RKMGeneral(fh,temp,y0,Butchers.ode45);
        y(1:length(y0),1:size(y_initial_test,1)) = y_initial_test';
        offset = size(y_initial_test,1)-k;
    else
        disp('Enough initial values for all steps :-)')
    end
    if isimplicit
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Method is implicit, root seeking needed.
        % Calculating all stages via Newton iteration with estimating the
        % Jacobian via finite difference step
        if opt.LMMDisp
            disp('Implicit Method found!')
        end
        for i = (1+offset):length(x)-k
            K = zeros(size(y0));
            for j = 1:k
                K = K + h(i)*b(j)*fh(x(i-1+j),y(:,i-1+j))-y(:,i-1+j)*a(j);
            end

            % Function to be solved
            fhsolve = @(ysearch) ysearch - (K + h(i)*b(end)*fh(x(i+s-1)+h(i),ysearch))/a(end);

            % Solver works with column vectors s.t. we need to plug in a
            % well shaped vector
            if strcmp(opt.Solver,'NewtonBroyden')
                ysolve = newtonsBroyden(fhsolve,y0(:),opt);
            elseif strcmp(opt.Solver,'fsolve')
                opts = optimoptions('fsolve','FunctionTolerance',1e-10,'OptimalityTolerance',1e-10,'StepTolerance',1e-10);
                ysolve = fsolve(fhsolve,y0,opts);
            elseif strcmp(opt.Solver,'Newton')
                ysolve = newtons(fhsolve,y0(:),opt);
%             elseif strcmp(opt.Solver,'TrustRegion')
%                 ysolve = trustregion(fhsolve,y0,opt);
            else
                error('Unknown solver! Please check your input options');

            end
            if opt.OptiOut
                disp(['Opti out at :',num2str(i),'/',num2str(length(x)-1)])
                disp(fhsolve(K))
            end

            y(:,i+k) = ysolve;
        end

    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Method is explicit, no root seeking needed.
        % Calculating all stages directly
        if opt.LMMDisp
            disp('Explicit Method found!')
        end

        for i = (1+offset):length(x)-k
            K = zeros(size(y0));
            for j = 1:k
                K = K + h(i)*b(j)*fh(x(i-1+j),y(:,i-1+j))-y(:,i-1+j)*a(j);
            end
            %                 K = (-a(3)*y(:,i+k-1) + h(i)*(b(1)*fh(x(i+k-3),y(:,i+k-3)) + b(2)*fh(x(i+k-2),y(:,i+k-2)) + b(3)*fh(x(i+k-1),y(:,i+k-1))))/a(4);
            y(:,i+k) = K/a(end);
        end
    end


    % to bring it in the same shape as ODE45
    y = y';
    x = x';

    timeout = toc;
    if opt.LMMDisp
        disp(['LMM Done. Time t=',num2str(timeout)])
    end
end

% function yout = newtons(fh,y0,opt)
%     %% Simple Newtons method.
%     if nargin < 3
%         opt.maxNewtonIter = 1000;
%         opt.Tol = 1e-15;
%         opt.FinalJacobianOut = false;
%         opt.JacobianPreDefined = false;
%         opt.FinDiffStep = 1e-8;
%     end
% 
%     e = 1;
%     y = y0;
%     count = 0;
%     delta = opt.FinDiffStep;
% 
%     F = fh(y) ;
% 
%     while e > opt.Tol && count < opt.maxNewtonIter
%         J = zeros(length(y0),length(y0));
% 
%         %% Estimate Jacobian via finite differences:
%         for i = 1: length(y0)
%             dy = zeros(length(y0),1);
%             dy(i) = delta;
%             fp = fh(y+dy);
%             fn = fh(y-dy);
%             J(:,i) = (fp-fn)/(2*delta);
%         end
%                 yold = y;
%         y = y - J\F;
% 
%         F = fh(y);
% 
%         e = norm(abs(y-yold));
%     %     e = max(abs(F));
%         count = count +1;
%         if (count == opt.maxNewtonIter)
%             warning('Newton seems to find no minimum')
%         end
%     end
%     if opt.FinalJacobianOut
%         disp('final Jacobian=');
%         disp(J);
%     end
%     yout = y;
% end

% 
% function yout = newtonsBroyden(fh,y0,opt)
%     %% Simple Newtons method.
%     if nargin < 3
%         opt.maxNewtonIter = 1000;
%         opt.Tol = 1e-15;
%         opt.FinalJacobianOut = false;
%         opt.JacobianPreDefined = false;
%         opt.FinDiffStep = 1e-8;
%     end
% 
%     e = 1;
%     y = y0;
%     count = 0;
%     delta = opt.FinDiffStep;
% 
%     fm = fh(y) ;
%     JF0 = zeros(length(y0),length(y0));
% 
%     %% Estimate first Jacobian via central differences:
%     for i = 1: length(y0)
%         dy = zeros(length(y0),1);
%         dy(i) = delta;
%         fp = fh(y+dy);
%         fn = fh(y-dy);
%         JF0(:,i) = (fp-fn)/(2*delta);
%     end
%     % Reassign intial values
%     F0 = fh(y0);
%     y = y0;
%     JF = JF0;
%     F = F0;
% 
%     % Optimize until constraints are met.
%     counter = 1;
% 
% 
%     while e > opt.Tol && (counter <= opt.maxNewtonIter)
%         s = -JF \ F;
%         % new solution
%         yold = y;
%         y = y + s;
% 
%         e = norm(y-yold);
%         % current function value
%         F = fh(y);
%         dF = (fh(y)-fh(y-s));
% 
%         % Approximate Jacobian with Broydens "good" method.
%         % % %         JF = JF + (F * s.') / (norm(s)^2);
%         % % %
%         dJ = (dF-JF*s)*s'/norm(s)^2;
%         JF = JF + dJ;
% 
%     %     e = norm(F-fh(y-s));
%         %         e = max(abs(F));
%         counter = counter + 1;
%     end
% 
%     % Output result
%     yout = y(:);
% end