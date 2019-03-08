function y = randspace(p1, n, p2, step_range, seed)
% RANDSPACE Generates a monotonically increasing sequence of randomly 
%           spaced values.
%
%   y = randspace(P1, N) generates N points greater than or equal to P1
%   with intervals between the points equal to random values in [0,1].
%
%   y = randspace(P1, N, P2) cuts off the generated sequence at P2.
%   NOTE: If P2 is set, the length of the generated sequence may be less
%   than N.
%
%   y = randspace(P1, N, P2, STEP_RANGE) generates the intervals between 
%   points according to STEP_RANGE.  STEP_RANGE must contain two elements 
%   indicating the minimum and maximum desired intervals. The first element
%   must be less than the second.  
%
%   y = randspace(P1, N, P2, STEP_RANGE, SEED) uses SEED as the state for
%   the random number generator.  SEED must be either a scalar or a 35 
%   element vector. See the doc for randn for details. 
%
%   Examples:
%       %generate 10 randomly spaced values starting at 0
%       y = randspace(0,10)
%       
%       %generate at most 10 randomly spaced values between 1 and 6
%       y = randspace(1, 10, 6)
%
%       %generate 10 values starting at 0 with intervals between 1 and 5
%       y = randspace(0,10,[],[1,5])
%
%       %generate 10 randomly spaced values starting at 0 using one state
%       y = randspace(0,10,[],[],1)    
%
%   Written by Dmitry Savransky, 18 June 2008

%check user inputs
if nargin < 2 || isempty(p1) || isempty(n)
    error('Starting point and number of points are required inputs.')
end


%if user supplied a state for rand, use it, otherwise set it to the current
%clock time.
if ~exist('seed','var') || isempty(seed)
    rand('state',sum(100*clock))
else
    if numel(seed) ~= 1 && numel(seed) ~= 35
        error('Seed must be scalar or 35-by-1.')
    end
    rand('state',seed(:));
end

%if user supplied a step range, use it, otherwise generate steps in [0 1]
if ~exist('step_range','var') || isempty(step_range)
    y = rand(1,n);
else
    if numel(step_range) ~= 2 || step_range(1) >= step_range(2)
        error('Step range must have two elements [a,b] such that a < b.')

    end
    y = step_range(1) + (step_range(2)-step_range(1)) * rand(1,n);
end

%generate sequence
y = y*triu(ones(n));
y = y+p1;

%if user supplied maximum value, use it
if exist('p2','var') && ~isempty(p2)
    y = y(y<=p2);
end
