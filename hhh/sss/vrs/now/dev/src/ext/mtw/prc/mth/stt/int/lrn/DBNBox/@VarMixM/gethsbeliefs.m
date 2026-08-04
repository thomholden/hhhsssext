function [Gamma]=gethsbeliefs(mix,varargin)
% [Gamma]=gethsbeliefs(mix)
% 
% returns posterior beliefs of hidden state chains
% 
% 

Gamma=cat(1,mix.hsnodes.Gamma.block{:});
