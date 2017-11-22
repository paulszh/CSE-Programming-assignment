function [convResult] = convolveSpatial(image, template)
    % rotate before convolution
    rotTemplate = imrotate(template,180);
    % convolution in spatial domain 
    convResult = conv2(image, rotTemplate);
end