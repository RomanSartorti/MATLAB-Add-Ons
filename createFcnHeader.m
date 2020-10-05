function createFcnHeader(inArg)
%%CREATEFCNHEADER is a function that will enease your creation of beatiful
% headers for your functions with the same style in every function
% 
% Creator: Roman Sartorti
% Hamburg, September 2020
% 
%  INPUT:
%     -   inArg:    (optional) predfining the header when calling the
%                   function (see example below)
%
% Examples:
% CREATEFCNHEADER() - opens a prompt where you can paste the function
% definition into - ATTENTION: definition needs to be copied BEFORE calling
% the function!
% CREATEFCNHEADER('[a,b] = myfun(x,y,z)') - returns directly the header into
% the terminal
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                   CHANGELOG                                  %
%   - 05.10.20: Replaced strrep by erase, output arguments are now shown       %
%               correctly                                                      %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1
    
prompt = {'Enter Function Name (full title with Input and Output):'};
dlgtitle = 'Input';
dims = [1 35];
definput = {''};
answer = inputdlg(prompt,dlgtitle,dims,definput);

if isempty(answer)
    warndlg('ATTENTION: there is no Name to create the header')
    return
end
else
    answer = inArg;
end
str = string(answer);
%% Separate Input and Output
C = strsplit(str,'=');
out = C{1};
try
    in = C{2};
catch
    in = out;
    out = [];
end
%% Reformat input
if ~isempty(in)
    C2 = strsplit(in,{'('});
    funName = C2{1};
    %% heady head
    head = upper(strrep(funName,' ',''));
    fprintf('%%%%%s \n',head)
    
    %% Input arguments
    try
        funIn = strrep(C2{2},')','');
        funIn = split(funIn,',');
        % Input
        fprintf('%%  INPUT:\n')
        for i = 1:length(funIn)
            fprintf('%%     -   %s:\n',funIn{i})
        end
    catch
        
    end
    
end

%% Reformat output
% [C2,matches] = strsplit(out,{',',']','['})
if ~isempty(out)
%     newChr = strrep(out,'[','');
%     newChr = strrep(newChr,[']',' '],'');
    newChr = erase(out,["[","]"," "]);
    funOut = split(newChr,[",","!"]);
    %% Create header
    fprintf('%%  OUTPUT:\n')
    for i = 1:length(funOut)
        fprintf('%%     -   %s:\n',funOut{i})
    end
end

% msgbox('Header now in Terminal. Ready to be copied.')
end