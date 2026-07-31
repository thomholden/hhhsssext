% convert datatype of inputimage based on string type
% 
% EXAMPLE
% 
% converdatatype(inputimage, 'int16'); converts array inputimage into
% 'int16' type.

function outputimg = convertdatatype(inputimage, type)

    t = type;
    outputimg = inputimage;
    switch t
        case 'uint8'
            outputimg=uint8(inputimage);
        case 'int16'
            outputimg=int16(inputimage);
        case 'int32'
            outputimg=int32(inputimage);
        case 'float32'
            outputimg=single(inputimage);
        case 'float64'
            outputimg=double(inputimage);
        case 'uint16';
            outputimg=uint16(inputimage);
        case 'uint32'
            outputimg=uint32(inputimage);
        case 'int64'
            outputimg=int64(inputimage);
        case 'uint64'
            outputimg=uint64(inputimage);
    end