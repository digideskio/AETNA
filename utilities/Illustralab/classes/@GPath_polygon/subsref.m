function b = subsref(s,index)
    switch index.type
        case '()'
            b = subsref(s.GPath,index);
        case '.'
            switch index.subs
                case 'xy'
                    b = s.xy;
                case 'linestyle'
                    b = s.linestyle;
                case 'linewidth'
                    b = s.linewidth;
                case 'edgecolor'
                    b = s.edgecolor;
                case 'decorations'
                    b = s.decorations;
                otherwise
                    b = subsref(s.GPath,index);
            end
    end
end