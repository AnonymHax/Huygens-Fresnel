% Checks missing toolboxes
function exitProg=toolboxRequiredAndMissing()
[w,plist] = matlab.codetools.requiredFilesAndProducts('interferenceMain.m');
exitProg = false;
v=ver;
for ii=2:length(plist)
    found=false;
    if plist(ii).Certain == 1
        for jj=1:length(v)
            found= strcmp(plist(ii).Name,v(jj).Name);
            if found
                break
            end
        end
        
        if (~found)
            disp(['Toolbox required and missing: ' plist(ii).Name]);
            exitProg = true;
        end
    end
end

if exitProg == false
    fprintf("All necessary toolboxes are installed\n");
end

return