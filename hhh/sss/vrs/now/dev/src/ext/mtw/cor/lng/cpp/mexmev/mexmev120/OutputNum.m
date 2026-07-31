classdef OutputNum
    %OutputNum Defines a numeric output argument for a C function
    %Constructor:
    %
    %OutputNum(name,dims,isreal,type)
    %
    %dims should be a valid C string, like '10,10' or 'x_n*10, 1' 
    %type should be one of:
    %
    %int8,uint8,int16,uint16,int32,uint32,int64,uint64,single,double
    properties
        isscalar = false;
        isreal = true;
        isfull = true;
        type = 'double';
        name = '';
        dims;
    end
    
    methods
        function this = OutputNum(name,dims,isreal,type)
            this.name = name;
            this.dims = dims;
            if nargin > 2
                this.isreal = isreal;
            end
            if nargin> 3
                this.type = type;
            end
        end
        
        function ret = display(this)
            a = CalcMD5(this.dims);
            ret = sprintf('%s_%d%d_%s_%s',this.name,this.isreal,this.isfull,this.type,a(1:6));
        end
    end
end

