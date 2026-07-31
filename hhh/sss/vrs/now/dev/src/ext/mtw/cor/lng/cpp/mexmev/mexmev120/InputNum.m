classdef InputNum
    %InputNum Defines a numeric input argument for a C function
    %Constructor:
    %
    %InputNum(name,isscalar,isreal,type,extracheck)
    %
    %type should be one of:
    %int8,uint8,int16,uint16,int32,uint32,int64,uint64,single,double
    properties
        isscalar = false;
        isreal = true;
        isfull = true;
        type = 'double';
        name = '';
        extracheck = '';
    end
    
    methods
        function this = InputNum(name,isscalar,isreal,type,extracheck)
            this.name = name;
            if nargin > 1
                assert(islogical(isscalar));
                this.isscalar = isscalar;
            end
            if nargin > 2
                assert(islogical(isreal));
                this.isreal = isreal;
            end
            if nargin> 3
                this.type = type;
            end
            if nargin> 4
                this.extracheck = extracheck;
            end
        end
        
        function ret = display(this)
            ret = sprintf('%s_%d%d%d_%s',this.name,this.isscalar,this.isreal,this.isfull,this.type);
        end
    end
end

