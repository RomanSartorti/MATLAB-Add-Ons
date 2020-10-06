classdef Butchers
    %BUTCHERS This class contains a lot of Butcher tableas
    
    properties
        StepSizeForImplicitMethod = 1e-8;
    end
    methods(Static)
        function Butcher = RK4
            Butcher     =  [ 0   0  0  0 0 ;
                            1/2 1/2 0  0 0;
                            1/2  0 1/2 0 0;
                            1    0  0  1 0;
                            0  1/6 1/3 1/3 1/6];
        end
        function Butcher = ExplicitEuler
            Butcher = [ 0 0;
                        0 1];
        end
        function Butcher = ImplicitEuler
            Butcher = [1 1 ;
                                 0 1];
        end
        function Butcher = ImprovedEuler
            Butcher = [ 0 0 0;
                        1 1/2 0;
                        0 0 1];
        end
        function Butcher = Ralston
            Butcher = [ 0 0 0;
                        2/3 2/3 0;
                        0 1/4 3/4];
        end
        function Butcher = DIRK
            Butcher = [ (0.5+sqrt(3)/6), (0.5 +sqrt(3)/6), 0;
                        (0.5-sqrt(3)/6), (-sqrt(3)/3)    , (0.5 + sqrt(3)/6);
                        0,              0.5,      0.5];
        end
        function Butcher = Gauss
            Butcher = [ (0.5 - 1/6*sqrt(3)), 0.25, (0.25 - 1/6*sqrt(3));
                        (0.5 + 1/6*sqrt(3)), (0.25 + 1/6*sqrt(3)), 0.25;
                        0, 0.5, 0.5];
        end
        function Butcher = Heun
            % Heuns method with adaptive stepsize
            Butcher = [ 0 0 0;
                        1 1 0;
                        2 1/2 1/2;
                        0 1 0];
        end
        function Butcher = ode23
            Butcher= [  0 0 0 0 0;
                        1/2 1/2 0 0 0;
                        3/4 0 0 0 0;
                        1 2/9 1/3 4/9 0;
                        3 2/9 1/3 4/9 0;
                        0 7/24 1/4 1/3 1/8];
        end
        function Butcher = ode45
            Butcher = [ 0   0 0 0 0 0 0 0;
                        1/5 1/5 0 0 0 0 0 0;
                        3/10 3/40 9/40  0 0 0 0 0;
                        4/5 44/45 -56/15 32/9 0 0 0 0;
                        8/9 19372/6561 -25360/2187 64448/6561 -212/729 0 0 0
                        1 9017/3168 -355/33 46732/5247 49/176  -5103/18656 0 0;
                        1 35/384     0      500/1113   125/192 -2187/6784 11/84 0 ;
                        5 35/384     0      500/1113   125/192 -2187/6784 11/84 0
                        0 5179/57600 0 7571/16695 393/640 -92097/339200 187/2100 1/40];
        end
        function Butcher = trapezoidal
            Butcher = [ 0 0 0;
                        1 1/2 1/2;
                        0 1/2 1/2];
        end
        function Butcher = DAEDirk
            Butcher.a = [1/2;1];
            Butcher.B = [1/2 0;1/2 1/2];
            Butcher.c = [1/2; 1/2];
        end
        
    end
end

