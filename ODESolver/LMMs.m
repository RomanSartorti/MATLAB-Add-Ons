classdef LMMs
    %LMMS Class containing a few Linea Multistep Methods
    
    properties
        
    end
    
    methods(Static)
        function Schema = BDF1
            Schema.a = [-1 1];
            Schema.b = [0 1];
        end
        function Schema = BDF2
            Schema.a = [1/2 -2 3/2];
            Schema.b = [0 0 1];
        end
        function Schema = BDF3
            Schema.a = [-1/3 3/2 -3 11/6];
            Schema.b = [0 0 0 1];
        end
        function Schema = BDF4
            Schema.a = [1/4 -4/3 3 -4 25/12];
            Schema.b = [0 0 0 0 1];
        end
        function Schema = BDF5
            Schema.a = [-1/5 5/4 -10/3 5 -5 137/60];
            Schema.b = [0 0 0 0 0 1];
        end
        function Schema = BDF6
            Schema.a = [1/6 -6/5 15/4 -20/3 15/2 -6 49/20];
            Schema.b = [0 0 0 0 0 0 1];
        end
        function Schema = AB1
            Schema.a = [-1 1];
            Schema.b = [1 0];
        end
        function Schema = AB2
            Schema.a = [0 -1 1];
            Schema.b = [-1/2 3/2 0];
        end
        function Schema = AB3
            Schema.a = [0 0 -1 1];
            Schema.b = [5 -16 23 0]/12;%[5/12 -16/12 23/12 0];
        end
        function Schema = AB4
            Schema.a = [0 0 0 -1 1];
            Schema.b = [-9/24 37/24 -59/24 55/24 0 ];
        end
        function Schema = AB5
            Schema.a = [0 0 0 0 -1 1];
            Schema.b = [251/720 -1274/720 2616/720 -2774/720 1901/720 0];
        end
        
        function Schema = AM1
            Schema.a = [-1 1];
            Schema.b = [1/2 1/2];
        end
        function Schema = AM2
            Schema.a = [0 -1 1];
            Schema.b = [-1/12 8/12 5/12];
        end
        function Schema = AM3
            Schema.a = [0 0 -1 1];
            Schema.b = [1/24 -5/24 19/24 9/24];
        end
        function Schema = AM4
            Schema.a = [0 0 0 -1 1];
            Schema.b = [-19/720 106/720 -264/720 646/720 251/720];
        end
        function Schema = AM5
            Schema.a = [0 0 0 0 -1 1];
            Schema.b = [27/1440 -173/1440 482/1440 -798/1440 1427/1440 475/1440];
        end
    end
end

