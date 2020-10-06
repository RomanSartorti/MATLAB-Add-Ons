function consistency = consistencyCheck(a,b)

    % check if length of a and b are equal
    if length(a) ~= length(b)
        error(['Length of [a] and [b] are not consistent'])
        return
    end
%% Checks order of consitency for some coeffienets [a] and [b]
    k = length(a);
    for i = 1:101
        l = i-1;
        temp = 0;
        for ii = 1:k
            j = ii-1;
            temp = temp + a(ii)*j^(l+1)-b(ii)*(l+1)*j^l;
        end

        if temp ~= 0 || sum(a)~=0
            if l == 0
                warning(['ODE not konsitent, Error = ',num2str(temp)]);
                consistency = 0;
                 break
            end
%             disp(['Order of consitency = ', num2str(l)])
            consistency = l;
            break
        end
    end
end