function y = NewtonSimple(fh,y0)
    
    %% Using GOOD Broydens method
    %
    J = zeros(length(y0));    
    F = fh(y0);
    % jacobian at initial point
    % calculate initial jacobian with finite differences
    hd = 1e-5;
    d = size(y0, 1);
    for j = 1:length(y0)
        
        J(:, j) = (fh(y0 + hd * (1:d==j).' ) - F) / hd;
    end
    
    
    counter = 0;
    maxIter = 1000;
    y_alt = y0;
    y_neu = zeros(size(y0));
    while max(abs(F)) > eps && counter < maxIter                %% Jacobian via finite differences
%         J = zeros(ly*s,ly*s);
%         for jix = 1:ly*s
%             dx = 0.00001;
%             Kdxp = K;
%             Kdxp(jix) = Kdxp(jix)+dx;
%             Kdxn = K;
%             Kdxn(jix) = Kdxn(jix)-dx;
%             J(:,jix) = (F(Kdxn,x(i),y(:,i),h(i))-F(Kdxp,x(i),y(:,i),h(i)))/(2*dx);
%         end
        % New iteration
        
        s = -J\fh(y_alt);
        
        y_neu = y_alt + s;
        
        % Current function value
        F = fh(y_neu);
        
        J = J + (F*s.')/norm(s)^2;
        
        
        counter = counter +1;

    end
    y = y_neu;

end

