function [x,y,timeout] = RKMGeneral(fh,x,y0, Butcher, opt)
%%RKMGENERAL method to solve an 
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
    %                                given by the input function [f,J]
    %       -   'FinDiffStep'       (default = 1e-8) stepsize for finite difference approximations 
    %       -   'TolAdaptive'       (default = 1e-3) Tolerance for adaptive
    %                               stepsize control

    optfields={'FinalJacobianOut','maxNewtonIter','Tol','OptiOut',...
        'ButcherDisp','Solver','JacobianPreDefined','FinDiffStep','TolAdaptive' };
    defaults = {false,10000,1e-8,false,false,'NewtonBroyden',false,1e-8,1e-5};
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

    % Checkig if Butcher is given. If not, use default (Order 3 Gauss method)
    if nargin <4
        Butcher = [ (0.5+sqrt(3)/6), (0.5 +sqrt(3)/6), 0;
            (0.5-sqrt(3)/6), (-sqrt(3)/3), (0.5 + sqrt(3)/6);
            0, 0.5, 0.5];
        disp(['No Butcher Tableau found. Taking default!']);
    end

    % Check if Butcher is already a struct, if not wrap the Matrix into a
    % struct with correct format.
    if ~isstruct(Butcher)
        Butcher = ButcherWraper(Butcher);
    end

    % Splitting Butcher
    a = Butcher.a;
    B = Butcher.B;
    c = Butcher.c;
    c_hat = Butcher.c_hat;
    p = Butcher.p;

    % number of stages
    s = length(a);
    
    %length of y
    ly = length(y0);
    
    %preallocate memory
    y = zeros(length(x),length(y0))';
    y(:,1) = y0;
    h = diff(x);
    K = zeros(s*ly,1);
    h_initial = max(h);

    %%% Displaying Butcher as so desired
    if opt.ButcherDisp
        fprintf('Butcher Tableau is defined as:\n')
        fprintf('a | B\n-----\n  |c\n\nButcher:\n')
        for idisp = 1:s
            fprintf('%4.2f |',a(idisp))
            fprintf(' %4.2g',B(idisp,:)')
            fprintf('\n')
        end
        fprintf('------------------\n     | ')
        fprintf(' %4.2g',c)
        fprintf('\n')
    end

    % Check if method is implicit
    isimplicit = trace(Butcher.B)~=0;
    
    % Check if method is adaptive
    isadaptive = ~isempty(Butcher.c_hat);
    if isadaptive && opt.ButcherDisp
        disp('Adaptive Method found!')
        fprintf('     | ')
        fprintf(' %4.2g',c_hat)
        fprintf('\n')
        disp(['With order p=',num2str(p)])
    end

    % start timer
    tic
    if isimplicit
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Method is implicit, root seeking needed.
        % Calculating all stages via Newton iteration with estimating the
        % Jacobian via finite difference step
        if opt.ButcherDisp
            disp('Implicit Method found!')
        end
        fhK = @(K) K - stages(K);
            for i = 1:length(x)-1
                K0 = K;
%                 fhK = @(K) K - stages(K);
                % Newton works with column vectors s.t. we need to plug in a
                % shaped K-vector instead of the matrix
    %             if (opt.Solver == 'NewtonB')
                if strcmp(opt.Solver,'NewtonBroyden')
    %                 K = newtons(fhK,K0(:),opt);
                    K = newtonsBroyden(fhK,K0(:),opt);
    %                 K = newtonsBFGS(fhK,K0(:),opt);
                elseif strcmp(opt.Solver,'fsolve')
                    opts = optimoptions('fsolve','FunctionTolerance',1e-10,'OptimalityTolerance',1e-10,'StepTolerance',1e-10);
                    K = fsolve(fhK,K0,opts);
                elseif strcmp(opt.Solver,'Newton')
                    K = newtons(fhK,K0(:),opt);
                elseif strcmp(opt.Solver,'TrustRegion')
%                     K = trustregion(fhK,K0,opt);
                else
                    error('Unknown solver! Please check your input options');

                end
                if opt.OptiOut
                    disp(['Opti out at :',num2str(i),'/',num2str(length(x)-1)])
                    disp(fhK(K))
                end
                dy = reshape(K,ly,s);
                y(:,i+1) = y(:,i)+h(i)*dy* c';
            end        
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Method is explicit, no root seeking needed.
        % Calculating all stages directly
        if opt.ButcherDisp
         disp('Explicit Method found!')
        end
        
        if ~isadaptive
            %% without stepsize control
            K = zeros(ly,s);
            for i = 1:length(y)-1
                for ki = 1:s
                    K(:,ki) = fh(x(i)+a(ki),y(:,i)+h(i)*(K*(B(ki,:)')));
                end
                y(:,i+1) = y(:,i)+h(i)*K*c';
            end
        else
            %% with stepsize control
            tau = opt.TolAdaptive;

            T = 0;
            Tend = max(x);
            i = 1;
            h = [h,zeros(size(h)),zeros(size(h)),zeros(size(h))];
            y = [y,zeros(size(y)),zeros(size(y)),zeros(size(y))];
            x = [x,zeros(size(x)),zeros(size(x)),zeros(size(x))];
            imax = length(x);
            h = sparse(h);
            y = sparse(y);
            x = sparse(x);
            K = zeros(ly,s);
            while T + h(i) <= Tend
                E = 0.5;
                while E < 1
                    for ki = 1:s
                        K(:,ki) = fh(x(i)+a(ki)*h(i),y(:,i)+h(i)*(K*(B(ki,:)')));
                    end

                    y(:,i+1) = y(:,i)+h(i)*K*c';

                    y_hat = y(:,i)+h(i)*K*c_hat';

                    deltay = max(norm(y(:,i+1)-y_hat),tau); 
                    E = (tau/(deltay))^(1/p);
                    h(i) = h(i)*E;

    %                 % bound maximal stepsize by initialized stepsize
    %                 if h(i) > 10*h_initial
    %                     h(i) = 10*h_initial;
    %                     break
    %                 end
                end
                T = T+h(i);
                x(i) = T;
                h(i+1) = h(i);
                i = i+1;
                if i == imax
                    warning('Couldn''t finish, stepsizes to small, s.t produced to much steps :-(')
                    return
                end
            end
        y = y(:,1:i);
        x = x(:,1:i);
        end
    end
        function stout = stages(K)
            % Function to return stages in vector form of length s*ly to work
            % with fsolve/newton algorithm.
            K = reshape(K,ly,s);
            stages = zeros(ly,s);
            for ii = 1:s
                stage = fh(x(i)+h(i)*a(ii),y(:,i)+h(i)*K*B(:,ii));
                if iscolumn(stage)
                    stages(:,ii) = stage;
                else
                    stages(:,ii) = stage';
                end
                stout = stages(:);
            end
        end

    % to bring it in the same shape as ODE45
    y = y';
    x = x';
    timeout = toc;
    
    if opt.ButcherDisp
        disp(['RKM Done. Time t=',num2str(timeout)])
    end
end

% function ButcherWrap = ButcherWraper(ButcherTab)
% %BUTCHERWR Wraps a Butcher Tableau in its splitted form if needed.
%     % Splitting Butcher
%     ButcherWrap = [];
%     stages = size(ButcherTab,2)-1;
%     isadaptive = stages+1<length(ButcherTab);
%     ButcherWrap.a = ButcherTab(1:stages,1);
%     ButcherWrap.B = ButcherTab(1:stages,2:end);
%     ButcherWrap.c = ButcherTab(stages+1,2:end);
%     if isadaptive
%         ButcherWrap.c_hat = ButcherTab(end,2:end);
%         ButcherWrap.p = ButcherTab(end-1,1);
%     else
%         ButcherWrap.c_hat = [];
%         ButcherWrap.p = [];
%     end
%     
% end
