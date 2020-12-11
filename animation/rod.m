classdef rod < handle
    %ROD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        length
        fh
        linewdith = 1 ;
        x
        y
        x_origin = 0;
        y_origin = 0;
    end
    
    methods
        function obj = rod(length,x,y)
            %ROD Construct an instance of this class
            %   Detailed explanation goes here
            obj.length = length;
            obj.x = x;
            obj.y = y;
            
            
            obj.fh = plot([obj.x_origin; x(1)],[obj.y_origin; y(1)],'-','LineWidth',obj.linewdith);
        end
%         function set.x(obj,x)
%             obj.x = x;
%             
%             refreshdata(obj.fh);
%         end
        
        function refresh(obj,x)
            obj.x = x;
            refreshdata(obj.fh);
        end
    end
end

