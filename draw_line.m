function[line_end] = draw_line(ax,x0,y0,z0,x1,y1,z1,R)

m = (y1-y0)/(x1-x0);

angle_take=atan2d((y1-y0),(x1-x0));

new_x = x0+R*cosd(angle_take);
new_y = y0+R*sind(angle_take);

line(ax,[x0,new_x],[y0,new_y],'linewidth',2,'color','k')

line_end = [new_x,new_y,0];


