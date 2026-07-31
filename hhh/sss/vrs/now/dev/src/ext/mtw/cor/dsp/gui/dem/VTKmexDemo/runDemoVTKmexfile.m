[x,y,z,v] = flow;
q = z./x.*y.^3;
mesh=isosurface(x, y, z, q, -.08, v);
[N,M]=size(mesh.faces);
scalars=linspace(0,1,N)';
vtkPolyDataRenderer(mesh.vertices,mesh.faces,scalars);
