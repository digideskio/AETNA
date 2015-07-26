function scalarcomplexvis
    % Visualization of solution of a complex first order ODE
    k =-0.13;
    %     k =-0.033+0.3i;
        k =-0.3i;
    % k =0.033+0.3i;
    % k =0.033;
    A=[real(k),-imag(k);imag(k),real(k)];
    rhsf =@(t,y) (A*y);
    y0=[8;0];
    y0=[8;-3];
    tspan =[0 60];
    options=odeset ('InitialStep', 0.099);
    [t,sol] = odetrap(rhsf, tspan, y0, options);
    xlim=[min(tspan),max(tspan)];
    ylim=[min(sol(:,1)),max(sol(:,1))];
    zlim=[min(sol(:,2)),max(sol(:,2))];
    mindim=min([diff(xlim),diff(ylim),diff(zlim)]);
    maxdim=max([diff(xlim),diff(ylim),diff(zlim)]);
    cdim =mean([mindim, maxdim])/50;
    hold on
    % line(t,sol(:,1),0*sol(:,2), 'linewidth', 2, 'color', 'red', 'marker', 'none')
    % line(t,0*sol(:,1),sol(:,2), 'linewidth', 2, 'color', 'blue', 'marker', 'none')
    line(0*t,sol(:,1),sol(:,2), 'linewidth', 2, 'color', 'black', 'marker', 'none')
    streamplot(t, [t,sol], cdim/4);
    view(3)
    grid on
    addlim =5*cdim;
    xlim=xlim+[-addlim,addlim];
    ylim=ylim+[-addlim,addlim];
    zlim=zlim+[-addlim,addlim];
        set(gca,'xlim',xlim,'ylim',ylim,'zlim',zlim);
    axis vis3d equal
    labels('$t$','$\mathrm{Re}\;y$','$\mathrm{Im}\;y$');
    
    
    [xs,ys,zs]=sphere(10);
    r=1.5*cdim/2;
    xs=r*xs;ys=r*ys;zs=r*zs;
    surfp=surf2patch(xs,ys,zs);
    p=patch('Vertices',surfp.vertices,'Faces',surfp.faces,...
        'FaceColor','black','EdgeColor','none');
    xs=get(p,'XData');
    ys=get(p,'YData');
    zs=get(p,'ZData');
    
    ts=t(1);
    xyz=sol(1,:);;
    set(p,'XData',xs+ts);
    set(p,'YData',ys+xyz(1));
    set(p,'ZData',zs+xyz(2));
    
    
    % cameratoolbar
    function  animate(obj, event, string_arg)
        dt= diff(tspan)/60;
        ts=t(1);
        xyz=sol(1,:);;
        set(p,'XData',xs+ts);
        set(p,'YData',ys+xyz(1));
        set(p,'ZData',zs+xyz(2));
        title(['$t$' '=' num2str(ts)],'interpreter','latex');;
        pause(0.1);
        for i=1:length(t)
            while t(i)>=ts+dt
                li =(ts+dt-t(i-1))/(t(i)-t(i-1));
                li1=(t(i)-ts-dt)/(t(i)-t(i-1));
                xyz=li*sol(i,:)+li1*sol(i-1,:);
                set(p,'XData',xs+ts+dt);
                set(p,'YData',ys+xyz(1));
                set(p,'ZData',zs+xyz(2));
                title(['$t$' '=' num2str(ts+dt)],'interpreter','latex');;
                pause(0.1);
                ts=ts+dt;
            end
        end
    end
    
    f = uimenu('Label','Animation');
    uimenu(f,'Label','Phase plot','Callback','view([90 0]);');
    uimenu(f,'Label','t vs. Im y','Callback','view([0 0]);');
    uimenu(f,'Label','t vs. Re y','Callback','view([0 90]);');
    uimenu(f,'Label','Animate','Callback',@animate);
end
% fig2clip