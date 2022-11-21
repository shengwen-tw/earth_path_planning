geo_planner = geography_planner;

geo_planner.draw_earth();
geo_planner.draw_waypoint(23.9037, 121.0794, 0)
geo_planner.draw_waypoint(-25.2744, 133.7751, 0)

if 0
lat_start = -90;
lat_end = 90;
long_start = -180;
long_end = 180;
delta = 10;

    for i = 1:(lat_end - lat_start) / delta
        for j = 1:(long_end - long_start) / delta
            lat = i * delta + lat_start;
            long = j * delta + long_start;
            geo_planner.draw_waypoint(lat, long, 0);
        end
    end
end

pause;
close all;