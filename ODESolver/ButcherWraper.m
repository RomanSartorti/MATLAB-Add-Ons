function ButcherWrap = ButcherWraper(ButcherTab)
%BUTCHERWR Wraps a Butcher Tableau in its splitted form if needed.
    % Splitting Butcher
    ButcherWrap = [];
    stages = size(ButcherTab,2)-1;
    isadaptive = stages+1<length(ButcherTab);
    ButcherWrap.a = ButcherTab(1:stages,1);
    ButcherWrap.B = ButcherTab(1:stages,2:end);
    ButcherWrap.c = ButcherTab(stages+1,2:end);
    if isadaptive
        ButcherWrap.c_hat = ButcherTab(end,2:end);
        ButcherWrap.p = ButcherTab(end-1,1);
    else
        ButcherWrap.c_hat = [];
        ButcherWrap.p = [];
    end
    
end

