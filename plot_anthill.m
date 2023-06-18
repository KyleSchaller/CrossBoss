% clear all
% close all
% clc

%select you probability value here.
pindx = .99;

B = dir;

xtotf = [];
ytotf = [];
ztotf = [];

for i = 3:length(B)
    load(B(i).name)
    xtotf = [xtotf; Data.x_tot];
    ytotf = [ytotf; Data.y_tot];
    ztotf = [ztotf; Data.z_tot];

    % ytotym = Data.y_tot;
    % ytotym = ytotym - 5;
    % ytotym = -1*ytotym;
    % ytotym = ytotym + 5;
    % 
    % xtotf = [xtotf; Data.x_tot];
    % ytotf = [ytotf; ytotym];
    % ztotf = [ztotf; Data.z_tot];
end    

indx = ztotf>-0;
ztotf(indx) = nan;
xtotf(indx) = nan;
ytotf(indx) = nan;

ztotf = ztotf(~isnan(ztotf));
ytotf = ytotf(~isnan(ytotf));
xtotf = xtotf(~isnan(xtotf));

figure
ax=gca
ax.Color = [.5,.5,.5];
% ax.DataAspectRatio = [1,1,1];
hold on

scatter3(xtotf,ytotf,ztotf,'MarkerEdgeColor','k','SizeData',5)

xgrid = 0:.1:10;
ygrid = 0:.1:10;

for i = 1:length(xgrid)-1
    for j = 1:length(ygrid)-1
        indx_t = xtotf >= xgrid(i) & xtotf < xgrid(i+1) & ytotf >= ygrid(j) & ytotf < ygrid(j+1);
        value_grid(i,j) = sum(indx_t);
    end
end


sorted = sort(value_grid(:),"ascend");

indx_length = length(sorted);
indx_take = floor(pindx*indx_length);

value_stop = sorted(indx_take);


value_grid(value_grid>value_stop) = value_stop;
figure
hold on
contourf(xgrid(1:end-1),ygrid(1:end-1),value_grid')
% caxis([1000,100000])
colormap('jet')
scatter(Data.X_loc,Data.Y_loc,'SizeData',200,'MarkerEdgeColor','w','MarkerFaceColor','k','LineWidth',4)