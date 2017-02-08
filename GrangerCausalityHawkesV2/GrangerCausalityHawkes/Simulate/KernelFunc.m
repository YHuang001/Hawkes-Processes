function g = KernelFunc( t, weight, freq, s, pattern )

% compute sine function-based kernel
% t: time
% weight: amplitude
% freq: frequency
% s: time shift
% pattern: 'sine' and 'square'

switch pattern
    case 'sine'
        g = weight*(1 - cos(2*pi*freq*t+pi*s ));
    case 'square'
        g = weight*2*round(0.5*(1 - cos(2*pi*freq*t+pi*s )));
    otherwise
        disp('Please assign a kernel function!');
end