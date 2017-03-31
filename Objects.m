classdef Objects
    properties
        Size
        Location
        Color
    end
    methods
        function object = update(object, size, centroid)
           object.Size = size;
           object.Location = centroid;
        end
    end
end