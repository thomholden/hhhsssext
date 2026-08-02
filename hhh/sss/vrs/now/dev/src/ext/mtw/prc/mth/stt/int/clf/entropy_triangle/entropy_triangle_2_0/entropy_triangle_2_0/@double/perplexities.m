function [n_Px,m_Py, g_MIxy, n_Px_y, m_Py_x, n, m, g_Px, g_Py]=perplexities(Pxy)
%  [n_Px,m_Py, g_MIxy, n_Px_y, m_Py_x, n, m, g_Px, g_Py]=perplexities(Pxy)
% a function to calculate and explore all possible perplexities from a bivariate
% probability distribution.
% 
% It obtains only:
% - the effective perplexity of the marginals n_Px m_Py
% - the perplexity gain of mutual information g_MIxy
% - the remanent perplexities n_Px_Y m_Py_X
% - the maximum perplexities (dimensions of Pxy) n m
% - the perplexity losses from the uniform distributions
%
% This is NOT what exploreETs uses (cfr. perplexities2)
%
% Authors: FVA, CPM, 2009-2014

%% Obtain the entropies
%% The effective perplexities
[H_Pxy, H_Px,H_Py, EMI_Pxy]=entropies(Pxy);
n_Px = 2.^(H_Px);
m_Py = 2.^(H_Py);
%The mutual information gain
if nargout < 3, return; end
g_MIxy = 2.^EMI_Pxy;
if nargout < 4, return; end
%the remanent perplexities
H_Py_x = H_Py - EMI_Pxy;
H_Px_y = H_Px - EMI_Pxy;
n_Px_y = 2.^(H_Px_y);
m_Py_x = 2.^(H_Py_x);
%The maximal perplexities are just the dimensions of the matrix
if nargout < 6, return; end
[n, m] = size(Pxy);
%The losses from the uniform distributions
if nargout < 8, return; end
g_Px = n ./ n_Px;
g_Py = m ./ m_Py;
return
