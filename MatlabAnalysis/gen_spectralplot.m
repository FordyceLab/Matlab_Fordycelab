clf
plot(xvals,Dy_norm,'k')
hold on
text(680,0.05,'Dy')
plot(xvals,Er_norm+0.15,'k')
text(680,0.18,'Er')
plot(xvals,Eu_norm+0.28,'k')
text(680,0.32,'Eu')
plot(xvals,Ho_norm+0.45,'k')
text(680,0.49,'Ho')
plot(xvals,Sm_norm+0.6,'k')
text(680,0.64,'Sm')
plot(xvals,Tm_norm+0.75,'k')
text(680,0.79,'Tm')

boundaries=boundary_set(find(sol_size<20));
yoffset=-0.02;
ywidth=0.01;
for n=1:size(boundaries,2)
    bounds=boundaries{n};
    for q=1:size(bounds,2)-1
        rectangle('Position',[bounds(q),yoffset,bounds(q+1)-bounds(q),ywidth]);
    end
    yoffset=yoffset-0.01;
end