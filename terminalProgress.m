classdef terminalProgress
%%TERMINALPROGRESS This class creates a progressbar in the terminal
%  INPUT:
%     -   maxIter:  maximum iterations
%     -   width:    (optional) line width
% 
% Creator: Roman Sartorti
% Hamburg, Oktober 2020
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 05.10.20: created function 
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        width = 4*20-1;
        maxIter;
        
    end
    properties(Access = private)
        reverseStr;
        tempStr;
    end
    
    methods
        function obj = terminalProgress(maxIter,width)
            %TERMINALPROGRESS Construct an instance of this class
            obj.maxIter = maxIter;
            
            if nargin > 1
                obj.width = width-1;
            end
            obj.reverseStr = repmat(sprintf('\b'), 1, obj.width+1);
            obj.tempStr = repmat(sprintf(' '), 1, obj.width+1);
        
            fprintf('Percent done: \n');
            fprintf(obj.tempStr);
        end
        
        function obj = update(obj,val)
            %%UPDATE function updating the progressbar
            %  INPUT:
            %     -   val:  new iteration value
            %  OUTPUT:
            %     -   obj:
            percentDone = obj.width * val / obj.maxIter;
            str = repmat('#',1,round(percentDone));
            msg = ['[',sprintf(str)]; %Don't forget this semicolon
            endStr = [repmat(' ',1,obj.width-length(msg)),']'];
        %     length([msg,endStr])
        %     fprintf(endStr);
            fprintf([obj.reverseStr, msg,endStr]);
            obj.reverseStr = repmat(sprintf('\b'), 1, obj.width);
        end
    end
end

