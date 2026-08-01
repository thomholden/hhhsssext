function uniquetri = compute_triangles_list(edg,N)
% all triangles (repeated)
alltri = [edg(:,[1,2,3]);edg(:,[1,2,4])];
% list of all triangles (unique)
uniquetri = unique(sort(alltri')','rows');
