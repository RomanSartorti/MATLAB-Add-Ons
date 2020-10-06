function convergenceRegions
%% Just a little scipt to create the stability region plots
LMM1 = LMMs.BDF4;

y.BDF4 = curveLMM(LMMs.BDF4);
y.AB4 = curveLMM(LMMs.AB4);
y.AM4 = curveLMM(LMMs.AM4);
fn = fieldnames(y);
figure(25)
for k=1:numel(fn)
    if( isnumeric(y.(fn{k})) )
        % do stuff
        plot(real(y.(fn{k})),imag(y.(fn{k})),'-','DisplayName',fn{k},'LineWidth',2)
        hold on
    end
end
legend('BDF4','AB4','AM4')

%% 
curveRK4
title('\bf Convergence regions for different solvers.')
end
function curveRK4
    % Plots the curve of the RK4 method via a little workaround: We use the
    % contourline at height 1 to see the stabiltiy region
    % based on:
    % https://ocw.mit.edu/courses/aeronautics-and-astronautics/16-90-computational-methods-in-aerospace-engineering-spring-2014/numerical-integration-of-ordinary-differential-equations/runge-kutta-methods/1690r-stability-regions/
    % Specify x range and number of points
    x0 = -3;
    x1 = 3;
    Nx = 301;
    % Specify y range and number of points
    y0 = -3;
    y1 = 3;
    Ny = 301;
    % Construct mesh
    xv = linspace(x0,x1,Nx);
    yv = linspace(y0,y1,Ny);
    [x,y] = meshgrid(xv,yv);
    % Calculate z
    z = x + 1i*y;
    % 2nd order Runge-Kutta growth factor
    % g = 1 + z + 0.5*z.^2;
    % 4nd order Runge-Kutta growth factor
    g = 1 + z + 1/2 * z.^2 + 1/6*z.^3+1/24*z.^4;
    % Calculate magnitude of g
    gmag = abs(g);
    % Plot contours of gmag
    contour(x,y,gmag,[1 1],'k-','LineWidth',2,'DisplayName','RK4');
    xlabel('Real($z$)');
    ylabel('Imag$(z)$');
    grid on;
end
function z = curveLMM(LMM)
    % Function to caclulate the curve of an LMM for a full circle
    t = 0:0.01:2*pi;
    for i = 1:length(t)
        z(i) = fh(t(i),LMM);
    end
end

function fhout =fh(phi,LMM)
    % Function to caclulate the values, based on the formula given in the
    % script.
    suma = 0;
    sumb = 0;
    for j = 1:length(LMM.a)
        suma = suma + LMM.a(j)*exp(1i*phi*(j));
        sumb = sumb + LMM.b(j)*exp(1i*phi*(j));
    end
    fhout = suma/sumb;
end
