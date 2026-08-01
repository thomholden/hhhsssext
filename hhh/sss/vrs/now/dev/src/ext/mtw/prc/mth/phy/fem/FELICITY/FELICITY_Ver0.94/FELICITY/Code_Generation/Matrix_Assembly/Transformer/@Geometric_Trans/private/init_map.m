function obj = init_map(obj)
%init_map
%
%   This initializes the local map form.

% Copyright (c) 02-20-2012,  Shawn W. Walker

obj = mesh_size(obj);

obj = value_map(obj);
obj = grad_map(obj);
obj = metric_map(obj); % 1st fundamental form
obj = det_metric(obj);
obj = inverse_det_metric(obj);
obj = inverse_metric_map(obj);

obj = det_jacobian(obj);
obj = det_jacobian_with_quadrature_weight(obj);
obj = inverse_det_jacobian(obj);
obj = inverse_grad_map(obj);

obj = tangent_vector(obj);
obj = normal_vector(obj);
obj = tan_space_proj(obj);

obj = hess_map(obj);
obj = inverse_hess_map(obj); % what is this for???
obj = second_fund_form(obj); % 2nd fundamental form
obj = det_second_fund_form(obj);
obj = inverse_det_second_fund_form(obj);

obj = total_curvature_vector(obj);
obj = total_curvature(obj);
obj = gauss_curvature(obj);

end