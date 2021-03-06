% Evaluates the volume of the structure
% XY34 = array of two rows, one for joint 3 and one for joint 4: their
%      coordinates in the X and Y direction
function V =tcant_volume(XY34)
    [XY,en,A,E,rho,W,Widx,addM,addMidx,...
        neqf,maxtipd,Lowestfreq] =tcant_data;
    XY([3,4],:) =XY34;
    V=0;
    for e=1:size(en,1)
        DeltaX=diff(XY(en(e,:),1));
        DeltaY=diff(XY(en(e,:),2));
        L= sqrt(DeltaX^2+DeltaY^2);
        V =V +A(e)*L;
    end
end
