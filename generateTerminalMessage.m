function generateTerminalMessage(msg,sign,nLine)
%%GENERATETERMINALMESSAGE this funtion creates a nice looking terminal
% output. This might be useful if you run long scripts to make sure that
% you know which subscript is actually in progress.
%
% Creator: Roman Sartorti
% Hamburg, Oktober 2020
%
%  INPUT:
%     -   msg:      string or cell array containing the message. If the 
%                   message is in one string, make sure the are seperated
%                   by a comma.
%     -   sign:     (optional, default = '#') defining the sign
%     -   nLine:    (optional, default = 4*20) linewidth
%
% Example: 
%   -   generateTerminalMessage('EXAMPLE,Message,take care of COMMA seperation!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 05.10.20: changed header, implemented usage of cell array or string
%               as message input 
%   - 23.11.20: solved bug when using structs instead of string
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 2
        sign = '#';
    end
    str = msg;
    
    if ~iscell(msg)
        C2 = strsplit(str,',');
    else
        C2 = string(str);
    end
    
    % Breite der Box
    if nargin < 3
        nLine = 4*20;
    end
        
%     nLine = round(num/4)*4 + mod(num,4) + 4;
    
    startEndLine = repmat(sign,1,nLine);
    if strcmp(sign,'%')
        sign = '%%';
    end
    
    fprintf('%s\n',startEndLine)
    for i = 1:length(C2)
        mlen = numel(C2{i})+2;          % Message length + 2 (for additional spaces)
        tabs = round((nLine-mlen)/2);   % Calculate necessary tabs from left edge to text
        fintabs = nLine-mlen-tabs;      % Calculate left over tabs for right edge
        strfintab = repmat(' ',1,fintabs);  % string containg final tabs
        strtab = repmat(' ',1,tabs);        % string containg start tabs
        
        inStr = append([sign,'%s%s%s',sign,'\n']);  % Connecting strings
        fprintf(inStr,strtab, C2{i},strfintab);     % print string
%             fprintf('%%%%%s \n',head)
    end
    fprintf('%s\n',startEndLine)

% % % %     Data = [  Tols' , error_c, error_dc];
% % % %     VarNames = {'Toleranz', sprintf('max(c(t=[0,%d]))', data.Initials.tspan(2)),...
% % % %         sprintf('max(dc(t=[0,%d]))', data.Initials.tspan(2))};
% % % % 
% % % %     fprintf("   ####################################################\n")
% % % %     fprintf('      Untersuchung der Toleranz an: %s\n' , data.System.names{jj} );
% % % %     fprintf(1,'      %s\t\t\t%s\t\t\t%s\n', VarNames{:})
% % % %     fprintf(1,'      \t%5.1i\t\t\t%0.8f\t\t\t\t%0.8f\t\n', Data')
% % % %     fprintf("   ####################################################\n\n\n")
end

