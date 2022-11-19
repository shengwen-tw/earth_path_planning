classdef geography_planner
    properties
        EQUATORIAL_RADIUS = 6378137     %[m], earth semi-major length (AE)
        POLAR_RADIUS = 6356752          %[m], earth semi-minor length (AP)
        AP_SQ_DIV_AE_SQ = 0.9933055218  %(AP^2)/(AE^2)
        ECCENTRICITY = 0.00669447819    %e^2 = 1 - (AP^2)/(AE^2)
        
        wp_marker_size = 150;
    end
    methods
        function ecef_pos = covert_geographic_to_ecef_frame(obj, latitude, longitude, height_msl)
            sin_lambda = sin(deg2rad(longitude));
            cos_lambda = cos(deg2rad(longitude));
            sin_phi = sin(deg2rad(latitude));
            cos_phi = cos(deg2rad(latitude));
            
            %convert geodatic coordinates to earth center earth fixed frame (ecef)
            N = obj.EQUATORIAL_RADIUS / sqrt(1 - (obj.ECCENTRICITY * sin_phi * sin_phi));
            ecef_x = (N + height_msl) * cos_phi * cos_lambda;
            ecef_y = (N + height_msl) * cos_phi * sin_lambda;
            ecef_z = (obj.AP_SQ_DIV_AE_SQ * N + height_msl) * sin_phi;
            
            ecef_pos = [ecef_x; ecef_y; ecef_z] / 1000; %[km]
        end
        
        function draw_earth(obj)
            grs80 = referenceEllipsoid('grs80','km');
            
            figure('Renderer','opengl')
            ax = axesm('globe','Geoid',grs80,'Grid','on', ...
                'GLineWidth',1,...
                'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
            ax.Position = [0 0 1 1];
            axis equal off
            view(200,20);
            
            load topo
            geoshow(topo,topolegend,'DisplayType','texturemap')
            demcmap(topo)
            land = shaperead('landareas','UseGeoCoords',true);
            plotm([land.Lat],[land.Lon],'Color','black')
            
        end
        
        function draw_waypoint(obj, latitude, longitude, altitude)
            [X,Y,Z] = sphere;
            ecef_pos = obj.covert_geographic_to_ecef_frame(latitude, longitude, altitude);
            surf((obj.wp_marker_size * X) + ecef_pos(1), ...
                (obj.wp_marker_size * Y) + ecef_pos(2), ...
                (obj.wp_marker_size * Z) + ecef_pos(3), ...
                'edgecolor','none', 'FaceColor', [1 0 0]);
        end
    end
end