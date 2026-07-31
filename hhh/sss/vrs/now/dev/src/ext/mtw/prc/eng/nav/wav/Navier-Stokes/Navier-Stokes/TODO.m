%TODO  Workflow I should make to complete the project

% - Make an install script (or function)
% - Compute the spectral coefficients to estimate the error (completed)
% - Use the method of manufactured solution to estimate error
% - During diagonalization, compute the eigenvalues only once (completed)
% - Do not compute the derivative matrix, only once (completed)
% - Compute omega on the boundary (completed)
% - Other temporal discretization schemes
% - Adaptive time-stepping
% - Extend the Stokes solver to Navier-Stokes solver
%   - time-independent solver
%   - time-dependent solver (completed)
% - Include temperature (completed)
% - Determine pressure if needed
% - Use different constitutive laws
% - Possibility of various boundary conditions
%   - outflow boundary condition
%   - wall, moving wall (completed)
%   - velocity inlet, etc. (completed)
% - Handle boundary conditions in both function handle and a numeric array
%   (completed)
% - Create a structure that hold the boundary conditions and the options
%    (like the odeset/odeget pair)
% - Overwrite the date of creation when functions are updated
% - Improve helps
% - Utility functions
%   - show tensor product mesh (completed)
%   - show the Chebyshev points on a unit circle (completed)
%   - show iteration on progress bar
%   - helper functions
% - Write documentation
% - Eliminate Kronecker product wherever possible (completed)
% - Visualization tools
%   - mesh, surface, vector, streamline plots (completed)
%   - error plot (log scale)
%   - animation for time-dependent case
% - Use the more stable barycentric interpolation instead of interp2
%     (completed)
% - Fast Poisson-solver
%   - use the weak form with Cholesky decomposition
%   - diagonalization (completed)
%   - iterative method using a non-equidistant FDM preconditioner
%   - make use of sparse matrices
% - FFT-based creation of spectral differentiation matrices
% - Use LU decomposition instead of inversion wherever possible
% - Iterative solver
%   - preconditioning
%   - spectral multigrid
% - Profiling for better speed (completed)
% - Less function overhead (completed)
% - Error estimation
%   - a posteriori estimation (completed)
%   - make an adaptive solver
% - Allow axisymmetric problems
% - Extension to rectangular domain
% - Execution on the GPU (not worth)
% - Use mex files if necessary
% - Turn to object oriented style
% - Make a GUI