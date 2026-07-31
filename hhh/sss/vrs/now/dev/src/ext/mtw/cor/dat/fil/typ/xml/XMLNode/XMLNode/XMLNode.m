classdef XMLNode < XMLNodeImpl
    %XMLNode requires a custom Java class to be on the dynamic path (so
    %that we can provide XML namespace support since we can't just pull it 
    %from the standard Java libraries). This XMLNode wrapper provides a
    %mechanism to ensure that the dynamic Java path is always added when a
    %user instantiates an XMLNode object.
    
    %Note that the Java path must be set before MATLAB looks at the 
    %XMLNodeImpl file, otherwise the custom Java class is not loaded 
    %correctly by the import statements. This is why this wrapper is in a 
    %separate file.
    %
    %Copyright 2012-2014 The MathWorks
    
    
    properties (Constant)
        %The Java class folders are located in the same folder as this
        %mfile
        javaPathReq = fileparts(mfilename('fullpath'));
    end
    methods (Static)
        %Javaaddpath does a "clear java", so this needs to be in its own
        %function
        function initialize
            javaaddpath(XMLNode.javaPathReq);
        end
    end
    methods
        %Wrapper for the actual XMLNode (XMLNodeImpl)
        function obj = XMLNode(node,xpath)
            if ~any(strcmp(XMLNode.javaPathReq,javaclasspath))
                XMLNode.initialize;
            end
            if ~exist('xpath','var')
                xpath = [];
            end
            obj@XMLNodeImpl(node,xpath);
        end
    end
end