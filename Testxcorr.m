%Test xcorr methods
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

            

            x_disp_max = w_width/2;
            y_disp_max = w_height/2;
            
            %initialize variables
            beforeWindow(w_width, w_height) = 0;
            afterWindow(w_width+2*x_disp_max, w_height+2*y_disp_max) = 0;
            dx(length(xgrid), length(ygrid)) = 0;
            dy(length(xgrid), length(ygrid)) = 0;
            
            xpeak1 = 0;
            ypeak1 = 0;
            
            for i = 1:length(xgrid)
                for j = 1:length(ygrid)
    
            max_correlation = 0;
           
            test_xmin = xgrid(i) - w_width/2;
            test_xmax = xgrid(i) + w_width/2;
            test_ymin = ygrid(j) - w_height/2;
            test_ymax = ygrid(j) + w_height/2;
            
           
            %create the before window
            beforeWindow = before(test_xmin:test_xmax, test_ymin:test_ymax);
            %create the after window
            afterWindow = after((test_xmin-x_disp_max):(test_xmax+x_disp_max),...
                (test_ymin-y_disp_max):(test_ymax+y_disp_max));
           
            %run the cross correlation using the normxcorr2 function
            correlation = normxcorr2(beforeWindow,afterWindow);
            
            %find the coordinates of the maximum in the correlation
            %matrices
            [xpeak(i,j), ypeak(i,j)] =  find(correlation == max(correlation(:)));
        
            %rescale the peak coordinates
            xpeak1(i,j) = test_xmin + xpeak(i,j) - wsize(1)/2 - x_disp_max;
            ypeak1(i,j) = test_ymin + ypeak(i,j) - wsize(2)/2 - y_disp_max;
          
            %compute the dx and dy
            dx(i,j) = xpeak1(i,j) - xgrid(i);
            dy(i,j) = ypeak1(i,j) - ygrid(j);
                end
            end
            %plot the vector field
            quiver(dy,-dx);