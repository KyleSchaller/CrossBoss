% Cleaned up version of Cross Calc function for Kyle
%
% by Silv

function cost = cross_calc2(variables,X_loc,Y_loc,xmin,xmax,ymin,ymax)

    % Set fixed RX locations
    X_locations = X_loc; 
    Y_locations = Y_loc;
    num_locs = length(X_locations);

    % Unload variables vector into locations
    num_vars = length(variables);
    x_points = variables(1:(num_vars/2));
    y_points = variables((num_vars/2)+1:end);
    num_points = length(x_points);
    
    % Compute Score A
    count = 0;
    m = zeros(num_points, num_locs);
    b = zeros(num_points, num_locs);
    lines = zeros(num_points * num_locs, 6);
    for i = 1:length(x_points)
        for j = 1:length(X_locations)
            count = count+1;
            lines(count,:) = [x_points(i),y_points(i),0,X_locations(j),Y_locations(j),0];
        end
    end
    
    P_final = nan * zeros(count * count, 3);
    count2 = 0;
    for i = 1:count
        for j = 1:count
            if i ~= j
                PA = [lines(i,(1:3));lines(j,(1:3))];
                PB = [lines(i,(4:6));lines(j,(4:6))];

                if (PA(1,1) ~= PA(2,1) | PA(1,2) ~= PA(2,2)) & (PB(1,1) ~= PB(2,1) | PB(1,2) ~= PB(2,2))
                    [P_int] = lineIntersect3D(PA,PB);

                    angle_line1 = atan2d((PA(1,2)-PB(1,2)),(PA(1,1)-PB(1,1)));
                    angle_line2 = atan2d((PA(2,2)-PB(2,2)),(PA(2,1)-PB(2,1)));

                    angle_point1 = atan2d((P_int(1,2)-PB(1,2)),(P_int(1,1)-PB(1,1)));
                    angle_point2 = atan2d((P_int(1,2)-PB(2,2)),(P_int(1,1)-PB(2,1)));


                    angle_delta1 = abs(angle_line1-angle_point1);
                    angle_delta2 = abs(angle_line2-angle_point2);

                    if angle_delta1<10 & angle_delta2 < 10
                        X_same = x_points - P_int(1);
                        Y_same = y_points - P_int(2);
                        X_same = abs(X_same) < .001;
                        Y_same = abs(Y_same) < .001;
                        Same1 = X_same & Y_same;

                        X_same2 = X_locations - P_int(1);
                        Y_same2 = Y_locations - P_int(2);
                        X_same2 = abs(X_same2) < .001;
                        Y_same2 = abs(Y_same2) < .001;
                        Same2 = X_same2 & Y_same2;

                        if P_int(1) >= xmin & P_int(1) <= xmax & P_int(2) >= ymin & P_int(2) <= ymax & sum(Same1) == 0 & sum(Same2)==0
                            count2 = count2+1;
                            P_final(count2,:) = P_int(1,:);
                        end
                    end
                end
            end
        end
    end

    idx_keep = ~isnan(P_final(:, 1));
    P_final = P_final(idx_keep, :);
    
    
    % Compute Score B
    x_bins = xmin:.2:xmax+.2;
    y_bins = ymin:.2:ymax+.2;
    num_xbins = length(x_bins);
    num_ybins = length(y_bins);
    
    x_take = zeros(num_xbins - 1, 1);
    y_take = zeros(num_ybins - 1, 1);
    C_contour = zeros(num_xbins - 1, num_ybins - 1);
    
    for i = 1:num_xbins - 1
        x_take(i) = (x_bins(i)+x_bins(i+1))/2;
        x_take(i) = x_bins(i);
        indx1 = P_final(:,1) >= x_bins(i) & P_final(:,1) < x_bins(i+1);

        for j = 1:num_ybins - 1
            y_take(j) = (y_bins(j)+y_bins(j+1))/2;
            y_take(j) = y_bins(j);
            indx2 = P_final(:,2) >= y_bins(j) & P_final(:,2) < y_bins(j+1);

            indx_total = indx1 & indx2;
            C_contour(i,j) = sum(indx_total);
        end
    end
    
    C_contour(C_contour>=20) = 20;
    
    
    [A,B] = size(C_contour);
    C_Area = A*B;
    
    indx_good = C_contour(C_contour>=1);
    num_good = length(indx_good);

    % Final score
    score = (count2/2)*((num_good)/C_Area);
    %score = (num_good)/C_Area;
    % Return cost
    cost = -score;
