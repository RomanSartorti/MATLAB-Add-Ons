function out = newtonCotes(fh,nSupports,xmin,xmax)
%%NEWTONCOTES Function for newton cotes integrals. Polynomials are
% calculated exactly up to order nSupports-1
%
% Creator: Roman Sartorti
% Hamburg, Oktober 2020
% 
%  INPUT:
%     -   fh:           function handle - make sure you use .*,.^ etc.
%     -   nSupports:    number of supporting points
%     -   xmin:         minimal value for x
%     -   xmax:         maximal value for x
%  OUTPUT:
%     -   out :         resulting output value
%
% EXAMPLE:
%   fh = @(x) x.^3+2*x+1;
%   out = newtonCotes(fh,2,-1,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 05.10.20: created function 
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load newtonCotesTabular.mat;
    
    interval = xmax-xmin;
    step = interval/(nSupports-1);
    
    xEvalPoints = [xmin:step:xmax]';
    xEval = fh(xEvalPoints);


    out = interval*newtonCotesTabular.(['n',num2str(nSupports-1)])*xEval;
end