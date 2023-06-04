function dragmarker(fig,ev,src)
%get current axes and coords
h1=gca;
coords=get(h1,'currentpoint');

%get all x and y data 
x=h1.Children(1).XData;
y=h1.Children(1).YData;

%check which data point has the smallest distance to the dragged point
x_diff=abs(x-coords(1,1,1));
y_diff=abs(y-coords(1,2,1));
[value index]=min(x_diff+y_diff);

%create new x and y data and exchange coords for the dragged point
x_new=x;
y_new=y;
x_new(index)=coords(1,1,1);
y_new(index)=coords(1,2,1);

%update plot
set(src,'xdata',x_new,'ydata',y_new);