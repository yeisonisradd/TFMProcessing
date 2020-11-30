%Yeison Rodriguez
clear;
before = imread('1 2_26_16 1kPa fluoresence before.tif');
after = imread('2 2_26_16 1kPa fluoresence after.tif');
[xmax, ymax] = size(before);
%window size
wsize = [64, 84];
w_width = wsize(1);
w_height = wsize(2);

%center points grid
xmin = w_width/2;
ymin = w_height/2;
xgrid = 65:w_width/2:960;
ygrid = 85:w_height/2:1260;

%number of windows in total

x_disp_max = w_width/2;
y_disp_max = w_height/2;

test_before(w_width, w_height) = 0;
test_after(w_width+2*x_disp_max, w_height+2*y_disp_max) = 0;
dpx(length(xgrid), length(ygrid)) = 0;
dpy(length(xgrid), length(ygrid)) = 0;
xpeak1 = 0;
ypeak1 = 0;
for i = 1:length(xgrid)
    for j = 1:length(ygrid)
    
        max_correlation = 0;
        test_xmin = xgrid(i) - w_width/2;
        test_xmax = xgrid(i) + w_width/2;
        test_ymin = ygrid(j) - w_height/2;
        test_ymax = ygrid(j) + w_height/2;
        x_disp = 0;
        y_disp = 0;
        test_before = before(test_xmin:test_xmax, test_ymin:test_ymax);
        test_after = after((test_xmin-x_disp_max):(test_xmax+x_disp_max),...
            (test_ymin-y_disp_max):(test_ymax+y_disp_max));
        correlation = normxcorr2(test_before,test_after);
        
        [xpeak(i,j), ypeak(i,j)] =  find(correlation == max(correlation(:)));
        
        %rescaling
        xpeak1(i,j) = test_xmin + xpeak(i,j) - wsize(1)/2 - x_disp_max;
        ypeak1(i,j) = test_ymin + ypeak(i,j) - wsize(2)/2 - y_disp_max;
        dpx(i,j) = xpeak1(i,j) - xgrid(i);
        dpy(i,j) = ypeak1(i,j) - ygrid(j);
    end
end
quiver(dpy,-dpx);
% c = normxcorr2(unreg,base);
% [max_c, imax] = max(abs(c(:)));
% [ypeak, xpeak] = ind2sub(size(c),imax(1));
% corr_offset = round([(xpeak-(size(c,2)+1)/2) (ypeak-(size(c,1)+1)/2)]);
% offset = corr_offset;
% xoffset = offset(1);
% yoffset = offset(2);