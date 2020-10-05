function out = newtonCotes2D(fh,nSupportsX,nSupportsY,xmin,xmax,ymin,ymax)
%%NEWTONCOTES2D Function for newton cotes integrals. Polynomials are
% calculated exactly up to order nSupports-1
%
% Creator: Roman Sartorti
% Hamburg, Oktober 2020
% 
%  INPUT:
%     -   fh:           function handle fh(x,y)
%     -   nSupportsX:   number of supporting points in x-direction
%     -   nSupportsX:   number of supporting points in y-direction
%     -   xmin:         minimal value for x
%     -   xmax:         maximal value for x
%     -   ymin:         minimal value for y
%     -   ymax:         maximal value for y
%  OUTPUT:
%     -   out:          resulting output value
%
% EXAMPLE:
%   fh = @(x,y) x^3+y^2;
%   out = newtonCotes2D(fh,2,3,-1,1,-1,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 05.10.20: created function 
%               eliminated loops by using clever matrix vector products
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    load('newtonCotesTabular.mat');
    
    intervalX = xmax-xmin;
    intervalY = ymax-ymin;
    stepX = intervalX/(nSupportsX-1);
    stepY = intervalY/(nSupportsY-1);
    X = xmin;
    Y = ymin;
    
    fEval = zeros(nSupportsX,1);
    
    result = 0;
    xx = xmin:stepX:xmax;
    yy = ymin:stepY:ymax;
    
    tmp = fh(xx,yy');
    result = newtonCotesTabular.(['n',num2str(nSupportsY-1)])*...
             tmp* newtonCotesTabular.(['n',num2str(nSupportsX-1)])';
%     for i =1:nSupportsX
%         wx = newtonCotesTabular.(['n',num2str(nSupportsX-1)])(i);
%         Y = ymin;
%         for j = 1:nSupportsY
%             wy = newtonCotesTabular.(['n',num2str(nSupportsY-1)])(j);
%             result = result + wx*wy*fh(X,Y);
%             Y = Y + stepY;
%         end
%         X = X + stepX;
%     end
    out = intervalX*intervalY*result;
%     out = interval*(newtonCotesTabular.(['n',num2str(nIntervalsX)]).*newtonCotesTabular.(['n',num2str(nIntervalsY)]))*fEval;
end