function scope=generate_scope(mesh, shape)

if nargin == 1
  warning('generate_scope.m: shape not specified - default to circle');
  shape='circle';
end


if shape == 'square'

  hspread=mesh(1);
  hshift_inc=mesh(2);
  vspread=mesh(3);
  vshift_inc=mesh(4);

  hlim=hshift_inc*fix(hspread/hshift_inc);
  hshifts=-hlim:hshift_inc:hlim;
  vlim=vshift_inc*fix(vspread/vshift_inc);
  hlen=length(hshifts);  
  vshifts = cell(1,hlen);
  for i=1:hlen
    vshifts{i} = -vlim:vshift_inc:vlim;
  end  

  angles = [0];

else

  rad=mesh(1);
  shift_inc=mesh(2);
  angle=mesh(3);
  angle_lim=mesh(4);

  hlim=shift_inc*fix(rad/shift_inc);
  hshifts=-hlim:shift_inc:hlim;
  vlims=shift_inc*fix(sqrt(rad^2-hshifts.^2)/shift_inc);
  hlen=length(hshifts);
  vshifts = cell(1,hlen);
  for i=1:hlen
    vshifts{i} = -vlims(i):shift_inc:vlims(i);
  end

  if angle_lim==Inf
     angles=0:angle:360-angle;
  else 
     angles=angle*(-angle_lim:angle_lim);
  end

end


  
scope=struct('hshifts', hshifts, 'vshifts', {vshifts},...
		'angles', angles);

