classdef terminalList < handle
%TERMINALLIST 
% Class to create lists in terminal, e.g. to show
% proceedings due to interatio processes. The user can define variable
% names that will be shown in the headline to make clear, which value
% stands for what.
% 
% Creator: Roman Sartorti
% Hamburg, Oktober 2020
%
% EXAMPLE1:
%     lst = terminalList({'Stress','strain','error'},'Spannungsuntersuchung am Biegebalken');
%     lst.setData([1,2,3]);
%     lst.termination;
% EXAMPLE2:
%     lst = terminalList({'stress','strain','failure index','error'});
%     for i = 1:10;
%       lst.setData(i*[1,2,3,4]);
%       pause(0.5)
%     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 04.10.20: created function 
%   - 05.10.20: now data is distributed well even if no variable names are
%               given
%   - 07.11.20: enlarged the distance to ensure that even negative numbers
%               fit the table pattern
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        % Box width
        nLine = 4*20;       % line width 
        symbol = '#';         % symbol to be used as limiter
        ListTitle {string}; % Title of the list
        varnames;           % cell array containing the variable names
    end
    properties(Access = protected)
        startendline;
        tabspaces = 18;
        numlen = 10;        % length of each numer in scientific notation
                            % 0.0000e+01
    end
    methods
        function obj = terminalList(varnames,ListTitle,symbol)
            %TERMINALLIST Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin >= 2
                obj.ListTitle = ListTitle;
            end
            if nargin == 3
                obj.symbol = symbol;
            end
            
            startEndLine = repmat(obj.symbol,1,obj.nLine);
            obj.startendline = startEndLine;
            if strcmp(obj.symbol,'%')
                obj.symbol = '%%';
            end
            
            if nargin >= 1
                obj.tabspaces = round(obj.nLine/(length(varnames)+1))+1;
                fprintf('%s\n',startEndLine)
                if nargin == 2
                    fprintf('%s\n',ListTitle)
                end
                obj.varnames = varnames;
                
                lastlen = round(obj.tabspaces/3);
                for i = 1:length(varnames)
                    strtab = repmat(' ',1,obj.tabspaces-lastlen);
                    fprintf('%s%s',[strtab,obj.varnames{i}])
                    lastlen = length(obj.varnames{i});
                end
                fprintf('\n')
            else
                warning('No Variable names predefined!')
                fprintf('%s\n',startEndLine)
            end
        end
        
        function setData(obj,data)
            %SETDATA function to set and output data
            if (length(data)~=length(obj.varnames) && ~isempty(obj.varnames))
                error('length of varnames and input data are not consitent!')
            end
            if isempty(obj.varnames)
                obj.tabspaces = round(obj.nLine/(length(data)+1));
            end
            
            lastlen = round(obj.tabspaces/3);
            for i = 1:length(data)
                % create white spaces ahead 
                strtab = repmat(' ',1,obj.tabspaces-lastlen);
                fprintf('%s%1.4e',strtab, data(i))
                lastlen = obj.numlen;
                
                % Check if number is negative to add an additional white
                % space to the prespace
                if sign(data(i)) == -1
                    lastlen = lastlen + 1;
                end
            end
            fprintf('\n')
        end
        function termination(obj)
            fprintf(obj.startendline);
            fprintf('\nProcess terminated \n')
        end
    end
end

