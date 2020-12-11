classdef animation < handle
    %ANIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig;
        animObjects;    % struct containing all animated objects
        
    end
    
    methods
        function obj = animation(figNum)
            %ANIMATION Construct an instance of this class
            %   Detailed explanation goes here
            if nargin <1
                figNum = 1;
            end
            obj.fig = figure(figNum);
            set(obj.fig,'Visible',true);
        end
        function refresh(obj)
            fields = fieldnames(obj.animObjects);
            lst = terminalList({'Rod Length'});
            for i  = 1:length(fields)
%                 disp(obj.animObjects.(fields{i}));
                lst.setData(obj.animObjects.(fields{i}).length);
            end
            lst.termination
        end
        
    end
end

